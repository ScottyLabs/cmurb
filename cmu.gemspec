# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'cmu'
  s.version     = '0.0.3'
  s.author      = 'Tom Shen'
  s.email       = 'tom@shen.io'
  s.homepage    = 'https://github.com/ScottyLabs/cmurb'
  s.summary     = %q{A library for CMU data}
  s.description = %q{cmurb provides a clean, simple interface for accessing CMU data. It currently only supports directory data.}
  s.license = 'MIT'
  s.files         = `git ls-files`.split("\n")
  s.require_paths = ['lib']

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'

  s.add_runtime_dependency 'net-ldap2'
end
