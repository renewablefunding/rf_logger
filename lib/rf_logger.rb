require "rf_logger/version"

module RfLogger
  def self.try_to_load(file)
    begin
      require file
      puts "RfLogger: Detected #{file}." if ENV["RF_LOGGER_LOAD_DEBUG"]
      yield
    rescue LoadError => e
      puts "RfLogger: #{file} not detected.\n\t#{e.to_s}" if ENV["RF_LOGGER_LOAD_DEBUG"]
    end
  end
end

RfLogger.try_to_load("rails")         { require "rf_logger/rails" }
RfLogger.try_to_load("active_record") { require "rf_logger/active_record" }
RfLogger.try_to_load("rory")          { require "rf_logger/rory" }
RfLogger.try_to_load("sequel")        { puts "RfLogger: require 'rf_logger/sequel'; before inheriting from RfLogger::Sequel::Logger" if ENV["RF_LOGGER_LOAD_DEBUG"] }
