# frozen_string_literal: true

require_relative 'item_parser'

module Yarss
  # Contains feed and item parsers.
  module Rss
    # Extract title, link, description and items from a parsed RSS feed.
    #
    # @see https://validator.w3.org/feed/docs/rss2.html#requiredChannelElements
    class FeedParser
      # Parsed RSS feed.
      #
      # @return [Hash]
      attr_accessor :data

      # @param data [Hash] Parsed RSS feed.
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

      # Extract the channel data.
      #
      # @raise [ParseError] If not found.
      #
      # @return [Hash]
      def feed
        @feed ||= data.fetch('rss').fetch('channel')
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
      # @raise [ParseError] If not found.
      #
      # @return [String]
      def link
        Attribute.link_value(feed.fetch('link'))
      rescue KeyError => e
        raise ParseError, e
      end

      # Extract the description.
      #
      # @return [String]
      def description
        Attribute.value(feed.fetch('description'))
      rescue KeyError => e
        raise ParseError, e
      end

      # Extract and parse the items.
      #
      # @raise [ParseError] If not found.
      #
      # @return [Array<Item>]
      def items
        items = feed.fetch('item')
        items = [items] unless items.is_a?(Array)
        items.map { |d| ItemParser.new(d).parse }
      rescue KeyError => e
        raise ParseError, e
      end
    end
  end
end
