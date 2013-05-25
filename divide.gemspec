require File.expand_path('../lib/divide/version', __FILE__)

spec = Gem::Specification.new do |s|
  s.name = 'divide'
  s.author = 'Etienne Lemay'
  s.email = 'etienne@heliom.ca'
  s.homepage = 'https://github.com/EtienneLem/'
  s.summary = 'Start Procfile processes in different Terminal.app tabs'

  s.version = Divide::VERSION
  s.platform = Gem::Platform::RUBY

  s.files = %w(LICENSE.md README.md Rakefile divide.gemspec)
  s.files += Dir.glob("lib/**/*.rb")
  s.files += Dir.glob("bin/**/*")

  s.bindir = 'bin'
  s.executables << 'divide'

  s.require_paths << 'lib'
end
