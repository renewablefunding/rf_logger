require "rf_logger/request/request_middleware"

module Rory
  class Application
    def spin_up
      Rory.application.use_middleware RfLogger::RequestMiddleware
      super
    end
  end
end
