# frozen_string_literal: true

module Yarss
  # A bunch of helpers to extract a +String+ value out of a +Hash+, +Array+,
  # etc.
  module Attribute
    # Extract a +String+ value from a given attribute.
    #
    # @raise [ParseError] If type of value is not known.
    #
    # @example
    #   Yarss::Attribute.value('Foo') # => 'Foo'
    #   Yarss::Attribute.value('__content__' => 'Foo') # => 'Foo'
    #
    # @param value [String, Hash] An attribute.
    #
    # @return [String]
    def self.value(value)
      value ||= ''

      case value
      when Hash
        value(value.fetch('__content__'))
      when String
        value.strip
      else
        raise ParseError, "Unknown #{value.class} attribute: #{value.inspect}"
      end
    rescue KeyError => e
      raise ParseError, e
    end

    # Extract a +String+ value from a given link attribute.
    #
    # @raise [ParseError] If type of value is not known or no link is found.
    #
    # @example
    #   Yarss::Attribute.link_value('Foo') # => 'Foo'
    #   Yarss::Attribute.link_value('href' => 'Foo') # => 'Foo'
    #   Yarss::Attribute.link_value([{ 'rel' => 'self', 'href' => 'Foo' }])
    #     # => 'Foo'
    #   Yarss::Attribute.link_value([{ 'rel' => 'alternate', 'href' => 'Foo' }])
    #     # => 'Foo'
    #
    # @param value [String, Hash, Array] A link attribute.
    #
    # @return [String]
    def self.link_value(value)
      value ||= ''

      case value
      when Hash
        link_value(value.fetch('href'))
      when Array
        item = value.find { |l| l.is_a?(String) } ||
               value.find { |l| l['rel'] && l['rel'] == 'self' } ||
               value.find { |l| l['rel'] && l['rel'] == 'alternate' }
        raise KeyError unless item
        link_value(item)
      when String
        value.strip
      else
        raise ParseError, "Unknown #{value.class} attribute: #{value.inspect}"
      end
    rescue KeyError => e
      raise ParseError, e
    end
  end
end
