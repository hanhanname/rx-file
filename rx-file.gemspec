# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'rx-file'
  s.version = '0.3.0'

  s.authors = ['Torsten Ruger']
  s.email = 'torsten@villataika.fi'
  s.extra_rdoc_files = ['README.md']
  s.files = %w(README.md LICENSE Rakefile) + Dir.glob("lib/**/*")
  s.homepage = 'https://github.com/ruby-x/rx-file'
  s.license = 'MIT'
  s.require_paths = ['lib']
  s.summary = 'Rubyx object file is the object file format of rubyx. It is a sort of condensed yaml'
end
