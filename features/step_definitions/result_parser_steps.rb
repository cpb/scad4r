Then /^the results should be an error$/ do
  last_results.should include(:error)
end

Then /^it should include timings$/ do
  last_results.should include(:real, :user, :sys)
end
