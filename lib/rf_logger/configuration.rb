module RfLogger
  # Stores configuration information
  #
  # Configuration information is loaded from a configuration block defined within
  # the client application.
  #
  # @example Standard settings
  #   RfLogger.configure do |c|
  #     c.notification_subject = "Oh no!"
  #     c.set_notifier_list do |n|
  #       c.add_notifier Notification::DefinedElsewhere, :levels => [:error], :except => ['test', 'development']
  #       c.add_notifier Notification::OhNo, :levels => [:fatal, :error], :only => ['production']
  #       c.add_notifer Notifcation:VeryVerbose
  #     end
  #     # ...
  #   end
  #
  class Configuration
    class << self
      def define_setting(name)
        defined_settings << name
        attr_accessor name
      end

      def defined_settings
        @defined_settings ||= []
      end
    end

    define_setting :environment
    define_setting :notification_subject

    def environment
      @environment ||= begin
        raise UndefinedSetting.new('RfLogger.environment must be set') unless framework_environment
        framework_environment
      end
    end

    def notifiers
      ErrorNotification.notifiers
    end

    def set_notifier_list
      yield(ErrorNotification)
    end

    def initialize
    end

    def clear!
      defined_settings.each {|setting| instance_variable_set("@#{setting}", nil)}
      ErrorNotification.reset!
    end

  private

    def defined_settings
      self.class.defined_settings
    end

    def framework_environment
      case
        when defined?(Rails) then Rails.env
        when defined?(Rory) then ENV['RORY_STAGE']
        when defined?(Padrino) then Padrino.environment
        when defined?(Sinatra::Application) then Sinatra::Application.environment
      end
    end
  end
end
