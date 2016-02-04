# frozen_string_literal: true

require 'bundler/setup'
require 'multi_xml'
require 'simplecov'

# Coverage tool, needs to be started as soon as possible
SimpleCov.start do
  add_filter '/spec/' # Ignore spec directory
end

require 'yarss'
