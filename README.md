# Yarss – Yet Another RSS Feed Normalizer.

Parse and access RSS/RDF/Atom feeds with a uniform interface. Yarss uses
[MutliXml](https://rubygems.org/gems/multi_xml) behind the scenes so you may
want to drop in your favourite XML parser.

For MRI users [Ox](https://rubygems.org/gems/ox) is highly recommended as it is
the fastest XML parser I know of. JRuby users should probably use
[Nokogiri](https://rubygems.org/gems/nokogiri).

## Usage

```ruby
['path/to/feed.rss', 'path/to/feed.atom', 'path/to/feed.rdf'].each do |file_path|
  feed = Yarss.new(file_path)

  puts "#{feed.title}, #{feed.link}, #{feed.description}"

  feed.items.each do |item|
    puts "#{item.id}, #{item.title}, #{item.updated_at}, #{item.link}"
    puts item.content
  end
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

