require 'active_record'
require "rf_logger/request_tags"

module RfLogger

  class RailsLogger < ActiveRecord::Base
    self.table_name = "logs"
    extend RequestTags
    class << self

      RfLogger::LEVELS.each do |level|
        define_method level.to_sym do |entry|
          add level, entry
        end
      end

      def add(level, entry)
        create(
          :rf_logger_request_tags => rf_logger_request_tags,
          :level => RfLogger::LEVELS.index(level.to_sym),
          :action => entry[:action],
          :actor => entry[:actor],
          :target_type => entry[:target_type],
          :target_id => entry[:target_id],
          :metadata => entry[:metadata]
        )
      end
    end
  end
end
