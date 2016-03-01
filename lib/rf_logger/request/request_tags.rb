require "thread/inheritable_attributes"

module RfLogger
  module RequestTags
    def rf_logger_request_tags
      Thread.current.get_inheritable_attribute(:rf_logger_request_tags)
    end

    def rf_logger_request_tags?
      rf_logger_request_tags.present? && rf_logger_request_tags.reject { |_, v| v.nil? }.count > 0
    end

    def merge_request_to_metadata(metadata)
      if metadata.is_a?(Hash) && rf_logger_request_tags?
        metadata.merge!(request_tags: rf_logger_request_tags)
      end
      metadata
    end
  end
end
