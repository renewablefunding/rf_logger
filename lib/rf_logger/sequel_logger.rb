module RfLogger
  class SequelLogger < Sequel::Model
    class << self
      RfLogger::LEVELS.each do |level|
        define_method level.to_sym do |entry|
          log = add level, entry

          notification_log = LogForNotification.new(entry.merge(:level => level))
          ErrorNotification.dispatch_error(notification_log)
          log
        end
      end

      def add(level, entry)
        entry[:level] = RfLogger::LEVELS.index(level.to_sym)
        entry[:actor] = entry[:actor] || ''
        entry[:metadata] = entry[:metadata] || {}
        entry[:created_at] = Time.now
        create(entry)
      end
    end

    def metadata
      JSON.parse(self[:metadata])
    end

    def metadata=(metadata_hash)
      self[:metadata] = metadata_hash.to_json
    end

    def display_level
      RfLogger::LEVELS[level]
    end
  end
end
