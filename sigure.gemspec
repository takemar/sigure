require_relative 'lig/sigure/version'

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
end
