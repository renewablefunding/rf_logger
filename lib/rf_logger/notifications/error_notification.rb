require_relative 'error_notification_environment_constraints'

class ErrorNotification
  class << self
    def configure(&block)
      yield self
    end

    def notifiers
      @@notifiers ||= Hash[RfLogger::LEVELS.map { |level| [level, []] }]
    end

    def add_notifier notifier, constraints={}
      levels = constraints.delete(:levels) || RfLogger::LEVELS
      constraint = ErrorNotification::EnvironmentConstraints.new(
        RfLogger.configuration.environment,
        constraints)
      if constraint.valid_notifier?
        levels.each do |level|
          notifiers[level] << notifier
        end
      end
    end

    def dispatch_error(log_info)
      # level is an integer, so find the one at the integer index
      level_nickname = RfLogger::LEVELS[log_info.level]
      notifiers[level_nickname].each do |notifier|
        notifier.send_error_notification log_info
      end
    end

    def reset!
      @@notifiers = nil; notifiers
    end
  end
end
