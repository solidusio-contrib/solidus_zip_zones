# encoding: UTF-8
$:.push File.expand_path('../lib', __FILE__)
require 'solidus_zip_zones/version'

Gem::Specification.new do |s|
  s.name        = 'solidus_zip_zones'
  s.version     = SolidusZipZones::VERSION
  s.summary     = 'Solidus zip zones'
  s.description = 'Create zone zip code based'
  s.license     = 'BSD-3-Clause'

  s.author   = 'Daniele Palombo'
  s.email    = 'danielepalombo@nebulab.it'
  s.homepage  = 'http://github.com/solidusio-contrib/solidus_zip_zones'

  s.files = Dir["{app,config,db,lib}/**/*", 'LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_runtime_dependency 'solidus_core',    ['>= 1.0', '< 3']
  s.add_runtime_dependency 'solidus_backend', ['>= 1.0', '< 3']
  s.add_runtime_dependency 'solidus_support'
  s.add_runtime_dependency 'deface', '~> 1.0'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'poltergeist'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_bot'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop', '0.47.1'
  s.add_development_dependency 'rubocop-rspec', '1.13.0'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
