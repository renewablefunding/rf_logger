require "rf_logger/request/request_middleware"

Rory.application.use_middleware RfLogger::RequestMiddleware
