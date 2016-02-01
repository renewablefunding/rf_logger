module RfLogger
  module RequestTags
    def rf_logger_request_tags
      (Thread.current[:inheritable_attributes] ||= {})[:rf_logger_request_tags] ||= {}
    end
  end
end
