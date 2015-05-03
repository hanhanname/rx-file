# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'salama-object-file'
  s.version = '0.1'

  s.authors = ['Torsten Ruger']
  s.email = 'torsten@villataika.fi'
  s.extra_rdoc_files = ['README.md']
  s.files = %w(README.md LICENSE Rakefile) + Dir.glob("lib/**/*")
  s.homepage = 'https://github.com/salama/salama-object-file'
  s.license = 'MIT'
  s.require_paths = ['lib']
  s.summary = 'Salama object file is the object file format of salama. It is a sort of condensed yaml'
end
