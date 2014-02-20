module RfLogger
  class SimpleLogger
    class << self
      def entries
        @entries ||= []
      end

      def add(level, entry)
        entries << { :level => RfLogger::LEVELS.index(level), :entry => entry, :level_name => level }
      end

      def clear!
        @entries = []
      end

      RfLogger::LEVELS.each do |level|
        define_method level.to_sym do |entry|
          add level, entry
        end
      end
    end
  end
end
