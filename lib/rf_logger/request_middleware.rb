module RfLogger
  class RequestMiddleware
    # @param [Hash] options
    # @option opts [Hash{:label => :request_method}] :tagged The subject
    # @option opts [Class] :rack_request_class
    def initialize(app, options={})
      @app                = app
      @tagged             = options.fetch(:tagged, { request_id: :uuid })
      @rack_request_class = options.fetch(:rack_request_class){request_class}
    end

    def call(env)
      @env = env
      set_tagged_thread_var
      @app.call(@env)
    end

    def tagged
      @tagged.each_with_object({}) do |(key, value), hash|
        hash[key] = request_object.send(value) if request_object.respond_to? value
      end
    end

    private

    def set_tagged_thread_var
      (Thread.current[:inheritable_attributes] ||= {})[:rf_logger_request_tags] = tagged
    end

    def request_object
      @request_object ||= @rack_request_class.new(@env)
    end

    def request_class
      case
      when defined? ActionDispatch::Request
        ActionDispatch::Request
      when defined? Rory::Request
        Rory::Request
      else
        raise ArgumentError, "Unknown framework context - :rack_request_class key needed."
      end
    end
  end
end
