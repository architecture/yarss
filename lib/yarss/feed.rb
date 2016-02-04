# frozen_string_literal: true

module Yarss
  # Feed data holder.
  class Feed
    # Title.
    #
    # @return [String]
    attr_accessor :title

    # URL to the related Web page.
    #
    # @return [String]
    attr_accessor :link

    # Description.
    #
    # @return [String]
    attr_accessor :description

    # Feed items.
    #
    # @return [Array<Item>]
    attr_accessor :items

    # @param attributes [Hash, nil] Data to set.
    def initialize(attributes = nil)
      attributes.each do |attribute, value|
        setter = "#{attribute}="
        send(setter, value)
      end if attributes
    end

    # Treat this class as a value object.
    #
    # @param other [Feed]
    #
    # @return [Bool]
    def ==(other)
      return false unless other.is_a?(self.class)

      title         == other.title       &&
        link        == other.link        &&
        description == other.description &&
        items       == other.items
    end
  end
end
