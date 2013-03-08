require 'bundler'

require 'simplecov'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')

require 'rspec/expectations'
require 'aruba/cucumber'

require 'scad4r/runner'
require 'scad4r/result_parser'

require 'pry'

module FeatureStateHelpers

  def last_results=(results)
    @results = results
  end

  def last_results
    @results
  end

  def runner=(a_runner)
    @runner = a_runner
  end

  def runner
    @runner
  end
end

World(FeatureStateHelpers)
