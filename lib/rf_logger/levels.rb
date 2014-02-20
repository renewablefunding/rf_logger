module RfLogger
  DEBUG = 0 # dev-only, for exploring issues
  INFO  = 1 # end users, to audit process
  WARN  = 2 # weird thing happened, but isn't really an issue
  ERROR = 3 # someone fix the code
  FATAL = 4 # system-wide errors

  LEVELS = [:debug, :info, :warn, :error, :fatal]
end
