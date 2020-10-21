# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'paubox/version'

Gem::Specification.new do |spec|
  spec.name          = 'paubox'
  spec.version       = Paubox::VERSION
  spec.authors       = ['Paubox']
  spec.email         = ['engineering@paubox.com']

  spec.summary       = "Paubox's Official Ruby SDK"
  spec.description   = 'Ruby SDK for interacting with the Paubox Transactional Email HTTP API.'
  spec.homepage      = 'https://www.paubox.com'
  spec.license       = 'Apache-2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.3'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'webmock', '~> 2.1'

  spec.add_dependency 'mail', '>= 2.5'
  spec.add_dependency 'rest-client', '~> 2.0', '>= 2.0.2'
end
