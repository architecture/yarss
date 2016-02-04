# frozen_string_literal: true

require_relative 'item_parser'

module Yarss
  # Contains feed and item parsers.
  module Atom
    # Extract title, link, description and items from a parsed Atom feed.
    #
    # @see http://atomenabled.org/developers/syndication/#requiredFeedElements
    class FeedParser
      # Parsed Atom feed.
      #
      # @return [Hash]
      attr_accessor :data

      # @param data [Hash] Parsed Atom feed.
      def initialize(data)
        self.data = data
      end

      # Parse out the feed title, link, description and items and wrap them
      # in a data object.
      #
      # @raise [ParseError] If a required field is not found.
      #
      # @return [Feed]
      def parse
        Feed.new(
          title:       title,
          link:        link,
          description: description,
          items:       items
        )
      end

      # Extract the feed data.
      #
      # @raise [ParseError] If not found.
      #
      # @return [Hash]
      def feed
        @feed ||= data.fetch('feed')
      rescue KeyError => e
        raise ParseError, e
      end

      # Extract the title.
      #
      # @raise [ParseError] If not found.
      #
      # @return [String]
      def title
        Attribute.value(feed.fetch('title'))
      rescue KeyError => e
        raise ParseError, e
      end

      # Extract the link.
      #
      # @return [String]
      def link
        Attribute.link_value(feed['link'] || '')
      end

      # Extract the description.
      #
      # @return [String]
      def description
        Attribute.value(feed['subtitle'] || '')
      end

      # Extract and parse the items.
      #
      # @raise [ParseError] If not found.
      #
      # @return [Array<Item>]
      def items
        items = feed.fetch('entry')
        items = [items] unless items.is_a?(Array)
        items.map { |d| ItemParser.new(d).parse }
      rescue KeyError => e
        raise ParseError, e
      end
    end
  end
end
