# frozen_string_literal: true

module Yarss
  module Rdf
    # Extract id, title, updated, link and content from a feed item.
    class ItemParser
      # Parsed Rdf feed item.
      #
      # @return [Hash]
      attr_accessor :data

      # @param data [Hash] Parsed Rdf feed item.
      def initialize(data)
        self.data = data
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
          content:    description
        )
      end

      # Extract the ID.
      #
      # @raise [ParseError] If not found.
      #
      # @return [String]
      def id
        if data['about']
          data['about']
        else
          data.fetch('rdf:about')
        end
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
        date = if data['date']
                 data['date']
               else
                 data.fetch('dc:date')
               end
        DateTime.parse(date)
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
        author = if data['dc:creator']
                   data['dc:creator']
                 else
                   data.fetch('creator')
                 end

        Attribute.value(author)
      rescue KeyError => e
        raise ParseError, e
      end

      # Extract the description.
      #
      # @return [String]
      def description
        Attribute.value(data.fetch('description'))
      rescue KeyError => e
        raise ParseError, e
      end
    end
  end
end
