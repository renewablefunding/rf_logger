require 'active_record'
require "rf_logger/request/request_tags"
require "rf_logger/levels"
require "rf_logger/file_system/logger"

module RfLogger
  module ActiveRecord
    class Logger < ::ActiveRecord::Base
      self.table_name = "logs"
      extend RfLogger::RequestTags
      class << self

        RfLogger::LEVELS.each do |level|
          define_method level.to_sym do |entry|
            add level, entry
            RfLogger::FileSystem::Logger.create_log(level, entry)
          end
        end

        def add(level, entry)
          attributes = {
            :level       => RfLogger::LEVELS.index(level.to_sym),
            :action      => entry[:action],
            :actor       => entry[:actor],
            :metadata    => merge_request_to_metadata(entry[:metadata] || {}),
            :target_type => entry[:target_type],
            :target_id   => entry[:target_id],
          }
          create(attributes)
        end
      end
    end
  end
end

RfLogger::RailsLogger = RfLogger::ActiveRecord::Logger
