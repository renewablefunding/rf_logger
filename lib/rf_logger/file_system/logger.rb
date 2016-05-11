require "rf_logger/levels"

module RfLogger
  module FileSystem
    class Logger
      extend RfLogger::RequestTags

      class << self
        RfLogger::LEVELS.each do |level|
          define_method(level.to_sym) do |entry|
            create_log(level, entry)
          end
        end

        def create_log(level, entry)
          log = {
            :timestamp   => Time.now.utc,
            :level       => level,
            :request_tag => rf_logger_request_tags,
            :action      => entry[:action],
            :actor       => entry[:actor],
            :metadata    => entry[:metadata],
            :target_type => entry[:target_type],
            :target_id   => entry[:target_id]
          }

          FileUtils.touch(file_path) unless File.exists?(file_path)
          File.open(file_path, 'a') { |f| f.puts log.to_json }
        end

        def file_path
          File.path(File.join(Dir.pwd, 'log', 'rf_logger.log'))
        end
      end
    end
  end
end
