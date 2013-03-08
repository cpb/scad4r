module OpenscadExecutionMatcher
  extend RSpec::Matchers::DSL

  def childprocess_double
    double("ChildProcess", start: true, wait: true,
          io: double("IO", "stdout=" => true, "stderr=" => true))
  end

  def write_pipe_double
    double("write pipe", close: true)
  end

  def read_pipe_double(result)
    StringIO.new(result || "")
  end

  matcher :run_openscad do |expected_openscad_command="openscad" |
    @expected_openscad_invocation = Array(expected_openscad_command)

    match do |openscad_runner|

      openscad_runner.stub(:pipes).and_return([
        read_pipe_double(@mock_result),write_pipe_double])

      ChildProcess.should_receive(:build) do |*arguments|
        options = arguments.pop if arguments.last.is_a?(Hash)

        arguments.shift(@expected_openscad_invocation.length).should eql(@expected_openscad_invocation)

        Array(@expected_arguments).each do |expected_argument|
          arguments.delete(expected_argument).should_not be_nil
        end

        arguments.last.should eql(@expected_input_file)

        childprocess_double
      end
    end

    chain :on do |expected_input_file|
      @expected_input_file = expected_input_file.to_s
    end

    chain :with do |expected_arguments|
      @expected_arguments = Array(expected_arguments)
    end

    chain :with_results do |mock_result|
      @mock_result = mock_result
    end
  end
end
