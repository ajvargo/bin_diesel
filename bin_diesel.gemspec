# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bin_diesel/version'

Gem::Specification.new do |spec|
  spec.name          = "bin_diesel"
  spec.version       = BinDiesel::VERSION
  spec.authors       = ["Andrew J Vargo", "Anthony White"]
  spec.email         = ["avargo@dataxu.com", "awhite@dataxu.com"]
  spec.description   = %q{Bin Diesel allows you to write scripts relying on Option Parser with DSL that eliminates the boiler plate code. Define options and run. }
  spec.summary       = %q{Easier "bin" scripts built with Option Parser.}
  spec.homepage      = "http://www.dataxu.com"
  spec.license       = "New BSD License"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
