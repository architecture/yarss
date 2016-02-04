# frozen_string_literal: true

require_relative 'item_parser'

module Yarss
  # Contains feed and item parsers.
  module Rdf
    # Extract title, link, description and items from a parsed Rdf feed.
    #
    # @see http://atomenabled.org/developers/syndication/#requiredFeedElements
    class FeedParser
      # Parsed Rdf feed.
      #
      # @return [Hash]
      attr_accessor :data

      # @param data [Hash] Parsed Rdf feed.
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
        @feed ||= begin
          if data['RDF']
            data['RDF']
          else
            data.fetch('rdf:RDF')
          end
        end
      rescue KeyError => e
        raise ParseError, e
      end

      # Extract the channel data.
      #
      # @raise [ParseError] If not found.
      #
      # @return [Hash]
      def channel
        @channel ||= feed.fetch('channel')
      rescue KeyError => e
        raise ParseError, e
      end

      # Extract the title.
      #
      # @raise [ParseError] If not found.
      #
      # @return [String]
      def title
        Attribute.value(channel.fetch('title'))
      rescue KeyError => e
        raise ParseError, e
      end

      # Extract the link.
      #
      # @raise [ParseError] If not found.
      #
      # @return [String]
      def link
        Attribute.link_value(channel.fetch('link'))
      rescue KeyError => e
        raise ParseError, e
      end

      # Extract the description.
      #
      # @return [String]
      def description
        Attribute.value(channel.fetch('description'))
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
