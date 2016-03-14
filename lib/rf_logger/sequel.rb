puts "RfLogger: Sequel version #{Sequel::VERSION}" if ENV["RF_LOGGER_LOAD_DEBUG"]
require "rf_logger/sequel/base"
require "rf_logger/sequel/logger"
