require "rf_logger/rails/rails_compatibility"
require "rails/version"
puts "RfLogger: Rails version #{Rails::VERSION::STRING}" if ENV["RF_LOGGER_LOAD_DEBUG"]
RfLogger::RailsCompatibility.new.call {
  require "rf_logger/rails/key_value_tagged_logging"
}
require "rf_logger/request/request_headers"
require "rf_logger/rails/initialize_request_middleware"
