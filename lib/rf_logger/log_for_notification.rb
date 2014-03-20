module RfLogger
  class LogForNotification
    attr_accessor :level
    def initialize(entry)
      @actor = entry[:actor]
      @action = entry[:action]
      @metadata = entry[:metadata]
      @level = entry[:level]
    end

    def subject
      interpolated_configured_subject ||
      "#{@level.upcase}! (#{@actor}/#{@action})"
    end

    def details
      YAML.dump @metadata
    end

    def interpolated_configured_subject
      if subject = RfLogger.configuration.notification_subject
        %w(actor action level).each do |variable|
          subject = subject.gsub("{{#{variable}}}", instance_variable_get("@#{variable}"))
        end
        subject
      end
    end
  end
end
