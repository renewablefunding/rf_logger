# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rf_logger/version'

Gem::Specification.new do |s|
  s.name        = 'rf_logger'
  s.version     = RfLogger::VERSION
  s.date        = '2014-02-20'
  s.summary     = "A logger that adheres to Renewable Funding logging conventions"
  s.description = "A logger that allows specification of severity, applicable entity/records, metadata, and optional notifications"
  s.authors     = ["Dustin Zeisler", "Dave Miller", "Laurie Kemmerer", "Maher Hawash", "Ravi Gadad"]
  s.email       = 'devteam@renewfund.com'
  s.homepage    = ''
  s.license     = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_runtime_dependency "thread-inheritable_attributes", "~> 0.2"
  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"
  s.add_development_dependency 'rspec', "~> 3.4"
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sequel'
  s.add_development_dependency 'activerecord'
end
