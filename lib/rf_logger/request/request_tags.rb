require "thread/inheritable_attributes"

module RfLogger
  module RequestTags
    def rf_logger_request_tags
      Thread.current.get_inheritable_attribute(:rf_logger_request_tags)
    end
  end
end
