class VimFormatter
  RSpec::Core::Formatters.register self, :example_failed

  class Entry
    def initialize(input)
      @input = input
    end

    def to_s
      "#{location}: #{message}"
    end

    private

    attr_reader :input

    def location
      input.example.location
    end
    
    def message
      input.exception.message + " " + backtrace
    end

    def backtrace
      input.exception.backtrace[0..10].join(" ")
    end
  end


  def initialize(output)
    @output = output
  end

  def example_failed(input)
    @output << Entry.new(input).to_s + "\n"
  end
end
