# frozen_string_literal: true
# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yarss/version'

Gem::Specification.new do |spec|
  spec.name          = 'yarss'
  spec.version       = Yarss::VERSION
  spec.authors       = ['Oldrich Vetesnik']
  spec.email         = ['oldrich.vetesnik@gmail.com']

  spec.summary       = 'Yet Another RSS Feed Normalizer.'
  spec.description   = 'Parse and access RSS/RDF/Atom feeds with ' \
                       'a uniform interface.'
  spec.homepage      = 'https://github.com/ollie/yarss'
  spec.license       = 'MIT'

  # rubocop:disable Metrics/LineLength
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # System
  spec.add_development_dependency 'bundler', '~> 1.11'
  # spec.add_development_dependency 'ox',       '~> 2.3'
  # spec.add_development_dependency 'nokogiri', '~> 1.6'
  # spec.add_development_dependency 'oga',      '~> 2.2'

  # Test
  spec.add_development_dependency 'rspec',     '~> 3.4'
  spec.add_development_dependency 'simplecov', '~> 0.11'

  # Code style, debugging, docs
  spec.add_development_dependency 'rubocop',    '~> 0.38'
  spec.add_development_dependency 'pry',        '~> 0.10'
  # spec.add_development_dependency 'pry-doc',    '~> 0.8'
  # spec.add_development_dependency 'pry-byebug', '~> 3.3'
  spec.add_development_dependency 'yard',       '~> 0.8'
  spec.add_development_dependency 'rake',       '~> 11.1'

  # Provides swappable XML backends utilizing LibXML, Nokogiri, Ox, Oga or REXML.
  spec.add_runtime_dependency 'multi_xml', '~> 0.5'
end
