# Yarss – Yet Another RSS Feed Normalizer. [![Build Status](https://travis-ci.org/ollie/yarss.svg?branch=master)](https://travis-ci.org/ollie/yarss) [![Gem Version](https://img.shields.io/gem/v/yarss.svg)](https://rubygems.org/gems/yarss)

Parse and access RSS/RDF/Atom feeds with a uniform interface. Yarss uses
[MutliXml](https://rubygems.org/gems/multi_xml) behind the scenes so you may
want to drop in your favourite XML parser.

For MRI users [Ox](https://rubygems.org/gems/ox) is highly recommended as it is
the fastest XML parser I know of. JRuby users should probably use
[Nokogiri](https://rubygems.org/gems/nokogiri).

## Usage

```ruby
# Parse from a String (raw XML), a Pathname, or an IO:
feed = Yarss.new('<xml string>...')
feed = Yarss.new(Pathname.new('path/to/feed.rss'))
feed = Yarss.new(File.open('path/to/feed.rss', 'rb'))

# Parse using IO-like, needs to respond to #read:
feed = Yarss.from_io(Pathname.new('path/to/feed.rss'))
feed = Yarss.from_io(File.open('path/to/feed.rss', 'rb'))

# Parse from a file path:
feed = Yarss.from_file('path/to/feed.rss')

# Parse from a string:
feed = Yarss.from_string('<xml string>...')

# Access feed attributes:
feed.title       # => "Foo's bars"
feed.link        # => 'http://foo.bar/'
feed.description # => 'Bars everywhere!'

# Access feed items:
feed.items.each do |item|
  item.id         # => 'id'
  item.title      # => 'Hello!'
  item.updated_at # => #<DateTIme ...>
  item.link       # => 'http://foo.bar/1'
  item.author     # => 'Joe'
  item.content    # => '<p>Hi!</p>'
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yarss'

# To increase performance, add one of these gems:
# gem 'ox'       # MRI compatible.
# gem 'nokogiri' # MRI and JRuby compatible.
# gem 'oga'      # MRI, JRuby, Rubinius compatible.
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yarss

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ollie/yarss.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

