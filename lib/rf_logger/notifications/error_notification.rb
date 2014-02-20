require_relative 'error_notification_environment_constraints'

class ErrorNotification
  class << self
    def configure(&block)
      yield self
    end

    def notifiers
      @@notifiers ||= []
    end

    def add_notifier notifier, constraints=nil
      constraint = ErrorNotification::EnvironmentConstraints.new(
        RfLogger.configuration.environment,
        constraints)
      if constraint.valid_notifier?
        notifiers << notifier
      end
    end

    def dispatch_error(log_info)
      notifiers.each do |notifier|
        notifier.send_error_notification log_info
      end
    end

    def reset!
      @@notifiers = []
    end
  end
end
