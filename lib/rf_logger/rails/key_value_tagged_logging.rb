require "rails/rack/logger"

module Rails
  module Rack
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

    Logger.prepend(TagsAsKeyValue)
  end
end

require "active_support/tagged_logging"

module ActiveSupport
  module RfTagsText
    def tags_text
      tags = current_tags
      if tags.any?
        tags.collect { |tag| "#{tag} " }.join
      end
    end
  end

  if defined? TaggedLogging::Formatter # Rails 4 or greater
    TaggedLogging::Formatter.prepend(RfTagsText)
  else
    TaggedLogging.prepend(RfTagsText) # Rails 3.2
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
    app.config.log_tags = { request_id: :uuid, remote_ip: :remote_ip }
  end
end
