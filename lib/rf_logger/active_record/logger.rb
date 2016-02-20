require 'active_record'
require "rf_logger/request/request_tags"
require "rf_logger/levels"

module RfLogger
  module ActiveRecord
    class Logger < ::ActiveRecord::Base
      self.table_name = "logs"
      extend RfLogger::RequestTags
      class << self

        RfLogger::LEVELS.each do |level|
          define_method level.to_sym do |entry|
            add level, entry
          end
        end

        def add(level, entry)
          attributes = {
            :level       => RfLogger::LEVELS.index(level.to_sym),
            :action      => entry[:action],
            :actor       => entry[:actor],
            :metadata    => entry[:metadata] || {},
            :target_type => entry[:target_type],
            :target_id   => entry[:target_id],
          }
          attributes[:metadata].merge!(request_tags: rf_logger_request_tags) unless rf_logger_request_tags.nil?
          create(attributes)
        end
      end
    end
  end
end

RfLogger::RailsLogger = RfLogger::ActiveRecord::Logger
