require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'scad4r/runner'

module Scad4r
  describe Runner do
    subject { described_class.new(timed: false) }

    describe "#run" do
      include OpenscadExecutionMatcher

      context "when passed a path" do
        let(:passed_file) {
          @fixture_path.join("scad").join("cube.scad") }

        it "runs with openscad" do
          subject.should run_openscad.on(passed_file)

          subject.run(passed_file)
        end

        it "is ok with a string too" do
          subject.should run_openscad.on(passed_file)

          subject.run(passed_file.to_s)
        end

        it "returns a hash describing the result" do
          IO.stub(:popen).and_return(StringIO.new)
          subject.run(passed_file).should be_a(Hash)
        end

        describe "result hash" do
          before do
            IO.stub(:popen).and_return(StringIO.new)
          end

          let(:parser) {
            double("Parser", parse: {fun: :results}) }

          subject { described_class.new(timed: false, parser: parser).run(passed_file) }

          it "should include the output file" do
            should include(output: passed_file.sub_ext(".stl"))
          end

          it "should inlcude the results of the parser" do
            should include(fun: :results)
          end
        end

        describe "options" do
          describe "as parameters override @options" do
            subject { described_class.new(timed: false, format: :stl) }

            it "runs with the option" do
              subject.should run_openscad.
                with("-o #{passed_file.sub_ext(".csg")}").
                on(passed_file)

              subject.run(passed_file, format: :csg)
            end
          end

          describe ":format" do
            context "format: :stl" do
              it "creates stl files" do
                subject.should run_openscad.
                  with("-o #{passed_file.sub_ext(".stl")}").
                  on(passed_file)

                subject.run(passed_file, format: :stl)
              end
            end

            context "format: :csg" do
              it "creates csg files" do
                subject.should run_openscad.
                  with("-o #{passed_file.sub_ext(".csg")}").
                  on(passed_file)

                subject.run(passed_file, format: :csg)
              end
            end
          end

          describe ":constants" do
            context "constants: {one: :assignment}" do
              it "runs with the constant set" do
                subject.should run_openscad.
                  with("-D 'one=\"assignment\"'").
                  on(passed_file)

                subject.run(passed_file, constants: {one: :assignment})
              end
            end

            context "constants: {two: :assignments, second: 1}" do
              it "runs with each constant set" do
                subject.should run_openscad.
                  with("-D 'two=\"assignments\"'",
                       "-D 'second=1'").
                  on(passed_file)

                subject.run(passed_file, constants: {two: :assignments, second: 1})
              end
            end
          end

          describe ":parser" do
            context "parser: double" do
              let(:parser) {
                double("Scad4r Result Parser", parse: {}) }

              let(:results) {
                "Some string of results" }

              it "parses the results with the parser" do
                parser.should_receive(:parse).with(results).and_return({})

                subject.should run_openscad.on(passed_file).with_results(results)

                subject.run(passed_file, parser: parser)
              end
            end
          end

          describe ":timed" do
            context "timed: true" do
              it "should invoke with time" do
                subject.should run_openscad("time","openscad").on(passed_file)

                subject.run(passed_file, timed: true)
              end
            end
          end
        end
      end
    end
  end
end
