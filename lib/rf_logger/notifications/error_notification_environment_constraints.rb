module RfLogger
  class ErrorNotification
    class EnvironmentConstraints
      def initialize(environment, constraints={})
        @constraints = constraints
        @environment = environment
      end

      def valid_notifier?
        @constraints.nil? || (included? && !excluded?)
      end

      def included?
        only = @constraints[:only]
        only.nil? || only.include?(@environment)
      end

      def excluded?
        except = @constraints[:except]
        return false if except.nil?
        except.include?(@environment)
      end
    end
  end
end
