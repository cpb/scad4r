# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', :version => 2, :notification => true do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^use_cases/(.+)\.rb$})     { |m| "spec/use_cases/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  watch('lib/dominos.rb')  { "spec" }

  # Rails example
  watch(%r{^spec/shared_examples\.rb$})                  { "spec" }
  watch(%r{^spec/shared_examples/(.+)\.rb$})                  { "spec" }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
end

guard 'cucumber' do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$})          { 'features' }
  watch(%r{^features/step_definitions/dominos_steps.rb$})          { 'features' }
  watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }

  watch('lib/dominos.rb')  { 'features' }
end
