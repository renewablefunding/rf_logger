require "rf_logger/request/request_middleware"

module Rory
  class Application

    alias_method :_spin_up, :spin_up

    def spin_up
      Rory.application.use_middleware RfLogger::RequestMiddleware
      _spin_up
    end
  end
end
