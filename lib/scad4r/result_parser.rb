module Scad4r
  class ResultParser
    def parse(result)
      case result
      when %r{Parser error in line (\d+): (.*)$}
        {error: "#{$2} line #{$1}"}
      when %r{Object isn't}
        {error: result}
      when %r{WARNING:}, %r{ECHO:}
        extract_timings(result).merge({
          warnings: extract_warnings(result),
          echos: extract_echos(result)})
      else
        extract_timings(result)
      end
    end

    protected
    def extract_warnings(result)
      find_messages(result, "WARNING")
    end

    def extract_echos(result)
      find_messages(result, "ECHO")
    end

    def extract_timings(result)
      {real: extract_time(result, :real),
        user: extract_time(result, :user),
        sys: extract_time(result, :sys)
      }
    end

    private

    def find_messages(result, message)
      found_messages = []
      message_regexp = /^#{message}: ([^\n]*)$/m
      scanner = StringScanner.new(result)
      while message = scanner.scan_until(message_regexp)
        found_messages << scanner.matched.match(message_regexp)[1]
      end

      found_messages
    end

    def extract_time(result, type)
      if matching = result.match(/([\d\.]+) #{type}/)
        matching[1]
      end
    end
  end
end
