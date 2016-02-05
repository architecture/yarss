# frozen_string_literal: true

module Yarss
  module Atom
    # Extract id, title, updated, link and content from a feed item.
    #
    # http://atomenabled.org/developers/syndication/#requiredEntryElements
    class ItemParser
      # Parsed Atom feed item.
      #
      # @return [Hash]
      attr_accessor :data

      # Feed link URL.
      #
      # @return [String]
      attr_accessor :feed_link

      # @param data      [Hash]   Parsed Atom feed item.
      # @param feed_link [String] Feed link URL.
      def initialize(data, feed_link: '')
        self.data      = data
        self.feed_link = feed_link
      end

      # Parse out the feed item id, title, updated, link and content and wrap
      # them in a data object.
      #
      # @raise [ParseError] If a required field is not found.
      #
      # @return [Item]
      def parse
        Item.new(
          id:         id,
          title:      title,
          updated_at: updated,
          link:       link,
          author:     author,
          content:    content
        )
      end

      # Extract the ID.
      #
      # @raise [ParseError] If not found.
      #
      # @return [String]
      def id
        data.fetch('id')
      rescue KeyError => e
        raise ParseError, e
      end

      # Extract the title.
      #
      # @raise [ParseError] If not found.
      #
      # @return [String]
      def title
        Attribute.value(data.fetch('title'))
      rescue KeyError => e
        raise ParseError, e
      end

      # Extract the updated date.
      #
      # @raise [ParseError] If not found.
      #
      # @return [DateTime]
      def updated
        DateTime.parse(data.fetch('updated'))
      rescue KeyError, ArgumentError => e
        raise ParseError, e
      end

      # Extract the link.
      #
      # @raise [ParseError] If not found.
      #
      # @return [String]
      def link
        Attribute.link_value(data.fetch('link'))
      rescue KeyError => e
        raise ParseError, e
      end

      # Extract the author.
      #
      # @raise [ParseError] If not found.
      #
      # @return [String]
      def author
        Attribute.author_value(data['author'] || '')
      end

      # Extract the content.
      #
      # @return [String]
      def content
        summary = Attribute.value(data['summary'] || '')
        content = Attribute.value(data['content'] || '')
        content = summary if content.empty?

        Attribute.absolutize_urls(content, feed_link)
      end
    end
  end
end
