require "rf_logger/request/request_middleware"

module RfLogger
  class InitializeRequestMiddleware < Rails::Railtie
    initializer "rf_logging.initialize_request_middleware" do |app|
      app.middleware.insert_after ::ActionDispatch::RequestId, RequestMiddleware
    end
  end
end
