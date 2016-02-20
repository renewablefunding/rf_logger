module RfLogger
  class RequestHeaders
    attr_reader :api_token, :type, :request_id, :content_type, :other

    def initialize(type: "application/json",
                   api_token: nil,
                   request_id: self.class.request_id,
                   other: {},
                   **other_key_headers)
      @type              = type
      @api_token         = api_token
      @request_id        = request_id
      @content_type      = type
      @other             = other
      @other_key_headers = other_key_headers
    end

    def self.request_id
      (Thread.current.get_inheritable_attribute(:rf_logger_request_tags)||{})[:request_id]
    end

    def to_hash
      {
        "Content-Type" => content_type,
        "Api-Token"    => api_token,
        "X-Request-Id" => request_id
      }.merge(other_key_headers).merge(other).reject { |_, v| v.nil? }
    end

    def other_key_headers
      @other_key_headers.each_with_object({}) { |(k, v), h| h[k.to_s.split("_").map(&:capitalize).join("-")] = v }
    end
  end
end
