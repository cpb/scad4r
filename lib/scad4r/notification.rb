module Scad4r
  class Notification
    class << self
      def parse(result)
        if error = result.fetch(:error, false)
          Array(new(error: error))
        else
          timings = if real = result.fetch(:real,nil)
                      new(success: real)
                    else
                      nil
                    end
          Array(result.fetch(:warnings,nil)).map do |warning|
            new(warning: warning)
          end + Array(result.fetch(:echos,nil)).map do |echo|
            new(echo: echo)
          end + Array(timings)
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
