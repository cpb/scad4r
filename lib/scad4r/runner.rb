module Scad4r
  class Runner
    class PassThrough
      def parse(result)
        {result: result}
      end
    end

    def initialize(options = {})
      @options = {format: :stl,
                  constants: {},
                  parser: PassThrough.new,
                  timed: true}.merge(options)
    end

    def run(path, options = {})
      net_options = @options.merge(options)

      parser = net_options.fetch(:parser)

      # provide a reasonable default
      net_options = {output: output_file(path, net_options)}.merge(net_options)

      io = IO.popen(openscad_invocation(path, net_options))

      result_hash = parser.parse io.read

      result_hash.merge({output: net_options.fetch(:output)})
    end

    private

    def openscad_invocation(path, options)
      [*openscad_command(options),*runtime_arguments(path, options), err: [:child, :out]]
    end

    def openscad_command(options)
      if options.fetch(:timed)
        %w(time openscad)
      else
        "openscad"
      end
    end

    def runtime_arguments(path, options)
      arguments = []

      arguments << "-o #{options.fetch(:output)}"

      arguments.push(*setting_constants(options.fetch(:constants)))

      # input file
      arguments << path.to_s
    end

    def output_file(path, options)
      extension = options.fetch(:format)
      Pathname.new(path).sub_ext(".#{extension}")
    end

    def setting_constants(assignments)
      assignments.inject([]) do |constants, (name, value)|
        constant = "#{name}="

        case value
        when String
          constant << value.inspect
        when Symbol
          constant << value.to_s.inspect
        else
          constant << value.to_s
        end

        constants << "-D '#{constant}'"
      end
    end

  end
end
