# frozen_string_literal: true

describe Yarss::Rss::FeedParser do
  let(:feed) { described_class.new(data) }
  let(:data) { {} }

  context 'parse raises Yarss::ParseError' do
    it { expect { feed.parse }.to raise_error(Yarss::ParseError) }
  end

  context 'parse' do
    let(:data) do
      {
        'rss' => {
          'channel' => {
            'title'       => 'Foo',
            'link'        => 'foo',
            'description' => 'Foo',
            'item'        => [
              {
                'guid'        => 'foo',
                'title'       => ' Foo ',
                'pubDate'     => 'Tue, 2 Feb 2016 15:27:00 +0100',
                'link'        => 'http://foo.bar/',
                'description' => 'Foo, Bar!'
              }
            ]
          }
        }
      }
    end

    it 'parse' do
      expect(feed.parse).to eq(
        Yarss::Feed.new(
          title:       'Foo',
          link:        'foo',
          description: 'Foo',
          items:       [
            Yarss::Item.new(
              id:         'foo',
              title:      'Foo',
              updated_at: DateTime.parse('2016-02-02T15:27:00+01:00'),
              link:       'http://foo.bar/',
              content:    'Foo, Bar!'
            )
          ]
        )
      )
    end
  end

  context 'feed not present' do
    it { expect { feed.feed }.to raise_error(Yarss::ParseError) }
  end

  context 'feed not present' do
    let(:data) { { 'rss' => { 'foo' => 'bar' } } }
    it { expect { feed.feed }.to raise_error(Yarss::ParseError) }
  end

  context 'feed' do
    let(:data) { { 'rss' => { 'channel' => { 'foo' => 'bar' } } } }
    it { expect(feed.feed).to eq('foo' => 'bar') }
  end

  context 'title not present' do
    let(:data) { { 'rss' => { 'channel' => {} } } }
    it { expect { feed.title }.to raise_error(Yarss::ParseError) }
  end

  context 'title' do
    let(:data) { { 'rss' => { 'channel' => { 'title' => 'Foo' } } } }
    it { expect(feed.title).to eq('Foo') }
  end

  context 'link not present' do
    let(:data) { { 'rss' => { 'channel' => {} } } }
    it { expect { feed.link }.to raise_error(Yarss::ParseError) }
  end

  context 'link' do
    let(:data) { { 'rss' => { 'channel' => { 'link' => 'foo' } } } }
    it { expect(feed.link).to eq('foo') }
  end

  context 'description not present' do
    let(:data) { { 'rss' => { 'channel' => {} } } }
    it { expect { feed.description }.to raise_error(Yarss::ParseError) }
  end

  context 'description' do
    let(:data) { { 'rss' => { 'channel' => { 'description' => 'Foo' } } } }
    it { expect(feed.description).to eq('Foo') }
  end

  context 'items not present' do
    let(:data) { { 'rss' => { 'channel' => {} } } }
    it { expect { feed.items }.to raise_error(Yarss::ParseError) }
  end

  context 'items' do
    let(:data) do
      {
        'rss' => {
          'channel' => {
            'item' => [
              {
                'guid'        => 'foo',
                'title'       => ' Foo ',
                'pubDate'     => 'Tue, 2 Feb 2016 15:27:00 +0100',
                'link'        => 'http://foo.bar/',
                'description' => 'Foo, Bar!'
              }
            ]
          }
        }
      }
    end

    it { expect(feed.items.size).to eq(1) }
  end

  context 'items' do
    let(:data) do
      {
        'rss' => {
          'channel' => {
            'item' => {
              'guid'        => 'foo',
              'title'       => ' Foo ',
              'pubDate'     => 'Tue, 2 Feb 2016 15:27:00 +0100',
              'link'        => 'http://foo.bar/',
              'description' => 'Foo, Bar!'
            }
          }
        }
      }
    end

    it { expect(feed.items.size).to eq(1) }
  end
end
