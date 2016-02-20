require "rails/rack/logger"

module Rails
  module Rack
    class Logger < ActiveSupport::LogSubscriber
      module TagsAsKeyValue
        def initialize(app, taggers={})
          super
          @taggers      = taggers.values
          @taggers_keys = taggers.keys
        end

        protected def compute_tags(*args)
          super(*args).collect.with_index do |value, index|
            "#{@taggers_keys[index]}=#{value}"
          end
        end
      end

      prepend TagsAsKeyValue
    end
  end
end

require "active_support/tagged_logging"

module ActiveSupport
  module TaggedLogging
    module Formatter
      def tags_text
        tags = current_tags
        if tags.any?
          tags.collect { |tag| "#{tag} " }.join
        end
      end
    end
  end
end

require "action_dispatch/middleware/request_id"

module ActionDispatch
  class RequestId
    private def internal_request_id
      [Rails.application.class.parent_name.underscore, SecureRandom.uuid].join("-")
    end
  end
end

require "rails/engine/railties"

class KeyValueKeyLogging < ::Rails::Railtie
  initializer "rf_logging.add_log_tag_request_id" do |app|
    app.config.log_tags = { request_id: :uuid }
  end
end
