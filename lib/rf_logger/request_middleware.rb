module RfLogger
  class RequestMiddleware
    def initialize(app, custom_env_key: nil)
      @app            = app
      @custom_env_key = custom_env_key
    end

    def call(env)
      @env = env
      Thread.current[:rf_logger_request_id] = custom_env_key || request_id
      @app.call(@env)
    end

    private

    def custom_env_key
      @env[@custom_env_key] if @custom_env_key
    end

    def request_id
      @env.uuid if @env.respond_to? :uuid
    end
  end
end
