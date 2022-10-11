# frozen_string_literal: true

$:.push File.expand_path('lib', __dir__)
require 'solidus_zip_zones/version'

Gem::Specification.new do |s|
  s.name        = 'solidus_zip_zones'
  s.author      = 'Daniele Palombo'
  s.email       = 'danielepalombo@nebulab.it'
  s.homepage    = 'http://github.com/solidusio-contrib/solidus_zip_zones'
  s.version     = SolidusZipZones::VERSION
  s.summary     = 'Solidus zip zones'
  s.description = 'Create zone zip code based'
  s.license     = 'BSD-3-Clause'

  s.required_ruby_version = Gem::Requirement.new('>= 2.5')

  s.files = Dir["{app,config,db,lib}/**/*", 'LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails'

  s.add_runtime_dependency 'solidus_backend', ['>= 1.0', '< 4.0']
  s.add_runtime_dependency 'solidus_core',    ['>= 1.0', '< 4.0']
  s.add_dependency 'solidus_support', '~> 0.5'
  s.add_runtime_dependency 'deface', '~> 1.0'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_bot'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'poltergeist'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'solidus_dev_support', '~> 2.5'
  s.add_development_dependency 'sqlite3'
end
