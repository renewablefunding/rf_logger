module RfLogger
  LEVELS = [
    :debug, # dev-only, for exploring issues
    :info , # end users, to audit process
    :warn , # weird thing happened, but isn't really an issue
    :error, # someone fix the code
    :fatal, # system-wide errors
  ]
end
