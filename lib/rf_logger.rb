require 'forwardable'
require 'rf_logger/version'
require 'rf_logger/configuration'
require 'rf_logger/levels'

require 'rf_logger/notifications/error_notification'
require 'rf_logger/notifications/error_notification_environment_constraints'

require 'rf_logger/simple_logger'

module RfLogger
  class UndefinedSetting < StandardError; end

  class << self
    extend Forwardable

    Configuration.defined_settings.each do |setting|
      def_delegators :configuration, setting, "#{setting.to_s}="
    end

    def configuration
      @configuration ||= RfLogger::Configuration.new
    end
  end
end
