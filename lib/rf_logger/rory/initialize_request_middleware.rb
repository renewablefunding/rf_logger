require "rf_logger/request/request_middleware"

Rory::Application.initializers.insert_after "rory.request_middleware", "rf_logger.request_middleware" do |app|
  app.middleware.insert_after Rory::RequestId, RfLogger::RequestMiddleware
end
