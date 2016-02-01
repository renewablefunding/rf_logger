module RfLogger
  class RequestMiddleware
    # @param [Hash] options
    # @option opts [Hash{:label => "header_name"}] :tagged The subject
    def initialize(app, options={})
      @app                = app
      @tagged             = options.fetch(:tagged, { request_id: "X-Request-Id" })
    end

    def call(env)
      @env = env
      set_tagged_thread_var
      @app.call(@env)
    end

    def tagged
      @tagged.each_with_object({}) do |(key, value), hash|
        hash[key] = @env[value]
      end
    end

    private

    def set_tagged_thread_var
      (Thread.current[:inheritable_attributes] ||= {})[:rf_logger_request_tags] = tagged
    end
  end
end
