require "rory/version"

if Gem::Version.new(Rory::VERSION) >= Gem::Version.new("0.8")
  puts "RfLogger: Rory version #{Rory::VERSION}" if ENV["RF_LOGGER_LOAD_DEBUG"]
  require "rf_logger/rory/initialize_request_middleware"
  require "rf_logger/request/request_headers"
else
  puts "RfLogger: requires Rory 0.8 or greater. Version #{Rory::VERSION} is not support." if ENV["RF_LOGGER_LOAD_DEBUG"]
end
