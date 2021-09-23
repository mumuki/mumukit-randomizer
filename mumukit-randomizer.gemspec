
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mumukit/randomizer/version'

Gem::Specification.new do |spec|
  spec.name          = 'mumukit-randomizer'
  spec.version       = Mumukit::Randomizer::VERSION
  spec.authors       = ['Julián Berbel Alt', 'Franco Bulgarelli']
  spec.email         = ['julian@mumuki.org', 'franco@mumuki.org']
  spec.summary       = 'Library for randomizing parts of mumuki exercises'
  spec.homepage      = 'http://github.com/mumuki/mumukit-randomizer'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/**']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_dependency 'activesupport'
  spec.add_dependency 'keisan', '~> 0.9'
end
