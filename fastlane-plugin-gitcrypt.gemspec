# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/gitcrypt/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-gitcrypt'
  spec.version       = Fastlane::Gitcrypt::VERSION
  spec.author        = 'Ben Sarrazin'
  spec.email         = 'ben@7swift.io'

  spec.summary       = 'fdjsklf'
  spec.homepage      = "https://github.com/bsarrazin/fastlane-plugin-gitcrypt"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'git'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop', '0.49.1'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'fastlane', '>= 2.76.0'
end
