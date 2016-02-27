require "rf_logger/request/request_middleware"
unless Gem::Version.new(Rory::VERSION) >= Gem::Version.new("0.8")
  raise "RfLogger require Rory 0.8 or greater. Version #{Rory::VERSION} is not support."
end
Rory::Application.initializers.insert_after "rory.request_middleware", "rf_logger.request_middleware" do |app|
  app.middleware.insert_after Rory::RequestId, RfLogger::RequestMiddleware
end
