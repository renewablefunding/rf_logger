require_relative 'error_notification_environment_constraints'

module RfLogger
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
        notifiers[log_info.level.to_sym].each do |notifier|
          notifier.send_error_notification log_info
        end
      end

      def reset!
        @@notifiers = nil; notifiers
      end
    end
  end
end
