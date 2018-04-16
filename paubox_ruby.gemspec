lib = File.expand_path('lib', __dir__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'paubox/version'

Gem::Specification.new do |spec|
  spec.name          = 'paubox'
  spec.version       = Paubox::VERSION
  spec.authors       = ['Paubox', 'Jonathan Greeley']
  spec.email         = ['jon.r.greeley@gmail.com']

  spec.summary       = "Paubox's Official Ruby SDK"
  spec.description   = "Ruby SDK for interacting with the Paubox Transactional Email HTTP API."
  spec.homepage      = 'https://www.paubox.com'
  spec.license       = 'Apache-2.0'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'webmock', '~> 2.1'
  spec.add_development_dependency 'pry'

  spec.add_dependency 'mail', '~> 2.6', '>= 2.6.4'
  spec.add_dependency 'rest-client', '~> 2.0', '>= 2.0.2'
end
