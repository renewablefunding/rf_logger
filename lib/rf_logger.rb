require 'forwardable'
require 'yaml'
require 'rf_logger/version'
require 'rf_logger/configuration'
require 'rf_logger/levels'

require 'rf_logger/notifications/error_notification'
require 'rf_logger/notifications/error_notification_environment_constraints'

require 'rf_logger/simple_logger'
require 'rf_logger/log_for_notification'


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

    def configure(&block)
      unless block
        raise ArgumentError.new("You tried to .configure without a block!")
      end
      yield configuration
    end

    def clear_configuration!
      @configuration = nil
    end

    def configure!(&block)
      unless block
        raise ArgumentError.new('You tried to .configure without a block!')
      end
      clear_configuration!
      yield configuration
    end
  end
end
