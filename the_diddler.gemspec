# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'the_diddler/version'

Gem::Specification.new do |spec|
  spec.name          = "the_diddler"
  spec.version       = TheDiddler::VERSION
  spec.authors       = ["Jeremiah"]
  spec.email         = ["jeremiah@cloudspace.com"]
  spec.summary       = %q{Convert external data into a more usable format}
  spec.description   = %q{Convert external data into a more usable format}
  spec.homepage      = "http://www.github.com/jeremiahishere/the_diddler"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
