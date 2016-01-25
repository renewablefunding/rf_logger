module RfLogger
  module RequestTags
    def rf_logger_request_tags
      Thread.current[:inheritable_attributes] = {} if Thread.current[:inheritable_attributes].nil?
      Thread.current[:inheritable_attributes][:rf_logger_request_tags] || {}
    end
  end
end
