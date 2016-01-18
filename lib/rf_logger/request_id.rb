module RfLogger
  module RequestId
    def request_id
      Thread.current[:rf_logger_request_id] || "uninitialized"
    end
  end
end
