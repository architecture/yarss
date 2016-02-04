# frozen_string_literal: true

module Yarss
  # Feed item data holder.
  class Item
    # ID.
    #
    # @return [String]
    attr_accessor :id

    # Title.
    #
    # @return [String]
    attr_accessor :title

    # Date and time of the last modification.
    #
    # @return [DateTime]
    attr_accessor :updated_at

    # URL to the related Web page.
    #
    # @return [String]
    attr_accessor :link

    # Content.
    #
    # @return [String]
    attr_accessor :content

    # @param attributes [Hash, nil] Data to set.
    def initialize(attributes = nil)
      attributes.each do |attribute, value|
        setter = "#{attribute}="
        send(setter, value)
      end if attributes
    end

    # Treat this class as a value object.
    #
    # @param other [Item]
    #
    # @return [Bool]
    def ==(other) # rubocop:disable Metrics/AbcSize
      return false unless other.is_a?(self.class)

      id           == other.id         &&
        title      == other.title      &&
        updated_at == other.updated_at &&
        link       == other.link       &&
        content    == other.content
    end
  end
end
