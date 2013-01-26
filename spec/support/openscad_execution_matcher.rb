module OpenscadExecutionMatcher
  extend RSpec::Matchers::DSL

  matcher :run_openscad do |expected_openscad_command="openscad" |
    @expected_openscad_invocation = Array(expected_openscad_command)

    match do |openscad_runner|
      IO.should_receive(:popen) do |arguments|
        options = arguments.pop if arguments.last.is_a?(Hash)

        arguments.shift(@expected_openscad_invocation.length).should eql(@expected_openscad_invocation)

        Array(@expected_arguments).each do |expected_argument|
          arguments.delete(expected_argument).should_not be_nil
        end

        arguments.last.should eql(@expected_input_file)

        StringIO.new(@mock_result||"")
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
