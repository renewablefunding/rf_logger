require 'simplecov'
SimpleCov.start
lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

require './lib/rf_logger'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.order = 'random'
end
