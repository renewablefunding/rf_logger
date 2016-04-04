require "thread/inheritable_attributes"

module RfLogger
  class RequestMiddleware
    REQUEST_ID_ENV = [
      /\.request_id/, # matches action_dispatch.request_id & rory.request_id
      "X-Request-Id", # If framework middleware has not been set fallback to default.
      "HTTP_X_REQUEST_ID"
    ].freeze

    # @param [Hash] options
    # @option opts [Hash{:label => ["header_name", /or regex/]}] :tagged match on rack request env keys. First value found has priority.
    def initialize(app, options={})
      @app    = app
      @tagged = options.fetch(:tagged, { request_id: REQUEST_ID_ENV })
    end

    def call(env)
      @env = env
      set_tagged_thread_var
      @app.call(@env)
    end

    def tagged
      @tagged.each_with_object({}) do |(label, matches), tags|
        [*matches].each do |match|
          break if (val = find_by(match)) && (tags[label] = val)
        end
      end
    end

    private

    def find_by(match)
      case match
      when String
        @env[match]
      when Regexp
        (@env.find { |k, _| match =~ k }|| []).last
      else
        raise "Unknown tagged match type: #{match}"
      end
    end

    def set_tagged_thread_var
      Thread.current.set_inheritable_attribute(:rf_logger_request_tags, tagged)
    end
  end
end
