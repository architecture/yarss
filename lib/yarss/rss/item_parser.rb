# frozen_string_literal: true

require 'digest'

module Yarss
  module Rss
    # Extract id, title, updated, link and content from a feed item.
    #
    # https://validator.w3.org/feed/docs/rss2.html#hrelementsOfLtitemgt
    class ItemParser
      # Parsed RSS feed item.
      #
      # @return [Hash]
      attr_accessor :data

      # Feed link URL.
      #
      # @return [String]
      attr_accessor :feed_link

      # @param data      [Hash]   Parsed RSS feed item.
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
          id:         guid,
          title:      title,
          updated_at: pub_date,
          link:       link,
          author:     author,
          content:    description
        )
      end

      # Extract the ID. Use the title if guid is not present and title is.
      #
      # @raise [ParseError] If not found.
      #
      # @return [String]
      def guid
        Attribute.value(data.fetch('guid'))
      rescue KeyError => e
        return Digest::MD5.hexdigest(data['title']) if data['title']
        raise ParseError, e
      end

      # Extract the title. Use guid if title is not present and guid is.
      #
      # @raise [ParseError] If not found.
      #
      # @return [String]
      def title
        Attribute.value(data.fetch('title'))
      rescue KeyError => e
        return Attribute.value(data['guid']) if data['guid']
        raise ParseError, e
      end

      # Extract the updated date.
      #
      # @return [DateTime]
      def pub_date
        DateTime.parse(data.fetch('pubDate'))
      rescue ArgumentError => e
        raise ParseError, e
      rescue KeyError
        DateTime.now
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
                 elsif data['creator']
                   data['creator']
                 elsif data['author']
                   data['author']
                 else
                   ''
                 end

        Attribute.value(author)
      end

      # Extract the content.
      #
      # @return [String]
      def description
        content = if data['content:encoded']
                    data['content:encoded']
                  elsif data['description']
                    data['description']
                  else
                    ''
                  end

        content = Attribute.value(content)
        Attribute.absolutize_urls(content, feed_link)
      end
    end
  end
end
