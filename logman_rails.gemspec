# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'logman_rails/version'

Gem::Specification.new do |spec|
  spec.name          = "logman_rails"
  spec.version       = LogmanRails::VERSION
  spec.authors       = ["Branko Krstic"]
  spec.email         = ["saicoder.net@gmail.com"]
  spec.description   = %q{This is a logman client for rails for sending errors to logman endpoint}
  spec.summary       = %q{This is a logman client for rails for sending errors to logman endpoint}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
