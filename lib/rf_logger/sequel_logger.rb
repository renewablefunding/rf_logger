require 'json'
require "rf_logger/request_id"

module RfLogger
  class SequelLogger < Sequel::Model(Sequel::Model.db.fetch('select 1'))
    extend RequestId

    class << self
      def inherited(subclass)
        super
        subclass.set_dataset underscore(demodulize(subclass.name.pluralize)).to_sym
      end

      RfLogger::LEVELS.each do |level|
        define_method level.to_sym do |entry|
          log = add level, entry

          notification_log = LogForNotification.new(entry.merge(:level => level))
          ErrorNotification.dispatch_error(notification_log)
          log
        end
      end

      def add(level, entry)
        entry[:request_id] = request_id
        entry[:level] = RfLogger::LEVELS.index(level.to_sym)
        entry[:actor] = entry[:actor] || ''
        entry[:metadata] = entry[:metadata] || {}
        entry[:created_at] = Time.now
        create(entry)
      end
    end

    def metadata
      return nil if self[:metadata].nil?
      JSON.parse(self[:metadata])
    end

    def metadata=(metadata_hash)
      metadata_as_json = metadata_hash.nil? ? nil : metadata_hash.to_json
      self[:metadata] = metadata_as_json
    end

    def display_level
      RfLogger::LEVELS[level]
    end
  end
end
