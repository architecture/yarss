# frozen_string_literal: true

require 'yarss/version'
require 'yarss/feed'
require 'yarss/item'
require 'yarss/attribute'
require 'yarss/rss/feed_parser'
require 'yarss/atom/feed_parser'
require 'yarss/rdf/feed_parser'

# RSS, RDF and Atom feeds parser.
module Yarss
  # Generic Yarss error.
  class Error < StandardError; end

  # Parsing of the XML failed or a required field is not present.
  class ParseError < Error; end

  # Not a RSS, RDF or Atom feed.
  class UnknownParserError < Error; end

  # Parse a {Feed} out of a path to a XML or an IO (or whatever responds
  # to +read+).
  #
  # @raise [UnknownParserError] If no corresponding parser was found.
  # @raise [ParseError]         If XML parsing or field extracting failed.
  #
  # @param path_or_io [String, #read] A path to the XML file or an IO, a
  #                                   Pathname, something that can be read.
  #
  # @example
  #   feed = Yarss.new('path/to/feed.rss')
  #
  #   puts "#{feed.title}, #{feed.link}, #{feed.description}"
  #
  #   feed.items.each do |item|
  #     puts "#{item.id}, #{item.title}, #{item.updated_at}, #{item.link}"
  #     puts item.content
  #   end
  #
  # @return [Feed]
  def self.new(path_or_io)
    if path_or_io.respond_to?(:read)
      from_io(path_or_io)
    else
      from_file(path_or_io)
    end
  end

  # Parse a {Feed} out of an IO (or whatever responds to +read+).
  #
  # @raise [UnknownParserError] If no corresponding parser was found.
  # @raise [ParseError]         If XML parsing or field extracting failed.
  #
  # @param io [#read] An IO, a Pathname, something that can be read.
  #
  # @example
  #   feed = Yarss.from_io(Pathname.new('path/to/feed.rss'))
  #   feed = Yarss.from_io(File.open('path/to/feed.rss', 'rb'))
  #
  #   puts "#{feed.title}, #{feed.link}, #{feed.description}"
  #
  #   feed.items.each do |item|
  #     puts "#{item.id}, #{item.title}, #{item.updated_at}, #{item.link}"
  #     puts item.content
  #   end
  #
  # @return [Feed]
  def self.from_io(io)
    data = io.read
    from_string(data, io)
  end

  # Parse a {Feed} out of a path to a XML.
  #
  # @raise [UnknownParserError] If no corresponding parser was found.
  # @raise [ParseError]         If XML parsing or field extracting failed.
  #
  # @param path [String] Path to a XML.
  #
  # @example
  #   feed = Yarss.from_file('path/to/feed.rss')
  #
  #   puts "#{feed.title}, #{feed.link}, #{feed.description}"
  #
  #   feed.items.each do |item|
  #     puts "#{item.id}, #{item.title}, #{item.updated_at}, #{item.link}"
  #     puts item.content
  #   end
  #
  # @return [Feed]
  def self.from_file(path)
    data = File.read(path)
    from_string(data, path)
  end

  # Parse a {Feed} out of raw XML.
  #
  # @raise [UnknownParserError] If no corresponding parser was found.
  # @raise [ParseError]         If XML parsing or field extracting failed.
  #
  # @param data       [String]        Raw RSS, RDF or Atom XML data.
  # @param path_or_io [String, #read] Path to a file or an IO.
  #
  # @example
  #   feed = Yarss.from_string('...)
  #
  #   puts "#{feed.title}, #{feed.link}, #{feed.description}"
  #
  #   feed.items.each do |item|
  #     puts "#{item.id}, #{item.title}, #{item.updated_at}, #{item.link}"
  #     puts item.content
  #   end
  #
  # @return [Feed]
  def self.from_string(data, path_or_io)
    data = MultiXml.parse(data)

    return Rss::FeedParser.new(data).parse  if data['rss']
    return Atom::FeedParser.new(data).parse if data['feed']
    return Rdf::FeedParser.new(data).parse  if data['rdf:RDF'] || data['RDF']

    raise UnknownParserError, "Cannot find parser for #{path_or_io}"
  rescue MultiXml::ParseError => e
    raise ParseError, e
  end
end
