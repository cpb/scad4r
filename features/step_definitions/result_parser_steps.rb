Then /^the results should be an error$/ do
  last_results.should include(:error)
end
