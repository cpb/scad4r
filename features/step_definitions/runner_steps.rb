Given /^I have a Scad4r::Runner$/ do
  self.runner= Scad4r::Runner.new
end

Given /^I have a Scad4r::Runner with a Scad4r::ResultParser$/ do
  self.runner= Scad4r::Runner.new(parser: Scad4r::ResultParser.new)
end

When /^I run "(.*?)" through the Scad4r::Runner$/ do |path|
  in_current_dir do
    self.last_results= runner.run(path)
  end
end
