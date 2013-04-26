module Scad4r
  class Notification
    class << self
      def parse(result)
        output = result.fetch(:output, nil)

        if error = result.fetch(:error, false)
          Array(new(error: with_output_path(error, output)))
        else
          timings = if real = result.fetch(:real,nil)
                      new(success: with_output_path(real, output))
                    elsif output
                      new(success: with_output_path("", output))
                    end
          Array(result.fetch(:warnings,nil)).map do |warning|
            new(warning: warning)
          end + Array(result.fetch(:echos,nil)).map do |echo|
            new(echo: echo)
          end + Array(timings)
        end
      end

      def with_output_path(message, output_path=nil)
        if output_path
          "-> #{output_path} #{message}"
        else
          message
        end
      end
    end

    attr_reader :message
    def initialize(attributes={})
      @type, @message = attributes.to_a.pop
    end

    def image
      case @type
      when :error
        :error
      when :warning
        :error
      when :echo, :success
        :success
      end
    end

    def title
      "openscad #{@type.to_s.upcase}"
    end

    def priority
      case @type
      when :error
        2
      when :warning
        1
      when :echo
        1
      when :success
        -1
      end
    end
  end
end
