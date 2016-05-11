require "json"
require "rf_logger/sequel/base"
require "rf_logger/request/request_tags"
require "rf_logger/file_system/logger"

module RfLogger
  module Sequel
    class Logger < ::Sequel::Model(::Sequel::Model.db.fetch('select 1'))
      extend RfLogger::RequestTags

      class << self
        def inherited(subclass)
          super
          subclass.set_dataset underscore(demodulize(subclass.name.pluralize)).to_sym
        end

        RfLogger::LEVELS.each do |level|
          define_method level.to_sym do |entry|
            log = add level, entry
            RfLogger::FileSystem::Logger.create_log(level, entry)

            notification_log = LogForNotification.new(entry.merge(:level => level))
            ErrorNotification.dispatch_error(notification_log)
            log
          end
        end

        def add(level, entry)
          entry[:level]    = RfLogger::LEVELS.index(level.to_sym)
          entry[:actor]    = entry[:actor] || ''
          entry[:metadata] = merge_request_to_metadata(entry[:metadata] || {})
          entry[:created_at] = Time.now
          create(entry)
        end
      end

      def metadata
        return nil if self[:metadata].nil?
        JSON.parse(self[:metadata])
      end

      def metadata=(metadata_hash)
        metadata_hash = self.class.merge_request_to_metadata(metadata_hash)
        metadata_as_json = metadata_hash.nil? ? nil : metadata_hash.to_json
        self[:metadata]  = metadata_as_json
      end

      def display_level
        RfLogger::LEVELS[level]
      end
    end
  end
end

RfLogger::SequelLogger = RfLogger::Sequel::Logger
