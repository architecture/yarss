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

    # Author.
    #
    # @return [String]
    attr_accessor :author

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
    def ==(other)
      return false unless other.is_a?(self.class)

      id           == other.id         &&
        title      == other.title      &&
        updated_at == other.updated_at &&
        link       == other.link       &&
        author     == other.author     &&
        content    == other.content
    end

    # Is the ID present?
    #
    # @return [Bool]
    def id?
      !id.nil? && !id.empty?
    end

    # Is the title present?
    #
    # @return [Bool]
    def title?
      !title.nil? && !title.empty?
    end

    # Is the date and time of the last modification present?
    #
    # @return [Bool]
    def updated_at?
      !updated_at.nil?
    end

    # Is the URL to the related Web page present?
    #
    # @return [Bool]
    def link?
      !link.nil? && !link.empty?
    end

    # Is the author present?
    #
    # @return [Bool]
    def author?
      !author.nil? && !author.empty?
    end

    # Is the content present?
    #
    # @return [Bool]
    def content?
      !content.nil? && !content.empty?
    end
  end
end
