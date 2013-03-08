Given /^I have a Scad4r::Runner$/ do
  self.runner= Scad4r::Runner.new
end

When /^I run "(.*?)" through the Scad4r::Runner$/ do |path|
  in_current_dir do
    self.last_results= runner.run(path)
  end
end
