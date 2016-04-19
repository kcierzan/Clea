# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clea/version'

Gem::Specification.new do |spec|
  spec.name          = "clea"
  spec.version       = Clea::VERSION
  spec.authors       = ["Kyle Cierzan", "Jeff Schneider", "David Valencia"]
  spec.email         = ["kcierzan+clea@gmail.com"]

  spec.summary       = %q{Send an email from the CLI using Ruby's SMTP library.}
  spec.description   = %q{For when alt-tabbing away from the terminal is just too much to ask...}
  spec.homepage      = "https://github.com/kcierzan/clea"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_runtime_dependency "ValidateEmail", "~> 1.0.1"
  spec.add_development_dependency "ValidateEmail", "~> 1.0.1"
end

# spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
