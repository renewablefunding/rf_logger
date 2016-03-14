puts "RfLogger: ActiveRecord version #{ActiveRecord::VERSION::STRING}" if ENV["RF_LOGGER_LOAD_DEBUG"]
require "rf_logger/active_record/logger"
