# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ufujs-rails/version', __FILE__)

Gem::Specification.new do |s|
  s.name          = 'ufujs-rails'
  s.version       = Ufujs::Rails::VERSION
  s.authors       = ['Alex Galushka']
  s.email         = ['galulex@gmail.com']
  s.homepage      = 'https://github.com/active-bridge/ufujs-rails'
  s.summary       = 'Dead simple remove file uploader for Rails'
  s.description   = 'Unobtrusive File Upload adapter for jQuery UJS and Rails.'
  s.platform      = Gem::Platform::RUBY

  s.files         = Dir['README.md', 'lib/**/*']
  s.require_path  = 'lib'

  s.add_development_dependency 'jquery-rails'
end
