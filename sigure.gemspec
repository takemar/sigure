require_relative 'lib/sigure/version'

Gem::Specification.new do |s|
  s.name = 'sigure'
  s.version = Sigure::VERSION
  s.license = 'MIT'
  s.summary = 'An implementation of HTTP Message Signatures'
  s.author = 'Takemaro'
  s.email = 'info@takemaro.com'
  s.files = Dir.glob('lib/**/*.rb')
  s.homepage = 'https://github.com/takemar/sigure'
  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/takemar/sigure/issues',
    'homepage_uri' => 'https://github.com/takemar/sigure',
    'source_code_uri' => 'https://github.com/takemar/sigure',
  }
  # s.required_ruby_version = '>= 3.2.2'
  s.add_runtime_dependency 'addressable', '~> 2.0.0'
  s.add_runtime_dependency 'starry', '~> 0.1.0'
end
