module RfLogger
  class RailsCompatibility
    MAX = "5.0.99"
    MIN = "3.2"
    Incompatible = Class.new(StandardError)

    def initialize(rails_version: Gem::Version.new(::Rails::VERSION::STRING))
      @rails_version = rails_version
    end

    def call
      if rails_supported?
        yield
      else
        rails_not_support_message
      end
    end

    private

    attr_reader :rails_version

    def rails_not_support_message
      raise Incompatible, "These patches change Rails private methods and are only known to work for Rails #{MIN} through #{MAX}"
    end

    def rails_supported?
      rails_version >= Gem::Version.new(MIN) && rails_version <= Gem::Version.new(MAX)
    end
  end
end


