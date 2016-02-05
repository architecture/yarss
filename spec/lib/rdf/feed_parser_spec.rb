# frozen_string_literal: true

describe Yarss::Rdf::FeedParser do
  let(:feed) { described_class.new(data) }
  let(:data) { {} }

  context 'parse raises Yarss::ParseError' do
    it { expect { feed.parse }.to raise_error(Yarss::ParseError) }
  end

  context 'parse' do
    let(:data) do
      {
        'rdf:RDF' => {
          'channel' => {
            'title'       => 'Foo',
            'link'        => 'foo',
            'description' => 'Foo'
          },
          'item' => [
            {
              'rdf:about'   => 'foo',
              'title'       => 'Foo',
              'dc:date'     => '2016-02-02T15:27:00+01:00',
              'link'        => 'http://foo.bar/',
              'dc:creator'  => 'Foo',
              'description' => 'Foo, Bar!'
            }
          ]
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
              author:     'Foo',
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

  context 'feed' do
    let(:data) { { 'rdf:RDF' => { 'foo' => 'bar' } } }
    it { expect(feed.feed).to eq('foo' => 'bar') }
  end

  context 'feed' do
    let(:data) { { 'RDF' => { 'foo' => 'bar' } } }
    it { expect(feed.feed).to eq('foo' => 'bar') }
  end

  context 'channel not present' do
    let(:data) { { 'rdf:RDF' => { 'foo' => 'bar' } } }
    it { expect { feed.channel }.to raise_error(Yarss::ParseError) }
  end

  context 'title not present' do
    let(:data) { { 'rdf:RDF' => { 'channel' => {} } } }
    it { expect { feed.title }.to raise_error(Yarss::ParseError) }
  end

  context 'title' do
    let(:data) { { 'rdf:RDF' => { 'channel' => { 'title' => 'Foo' } } } }
    it { expect(feed.title).to eq('Foo') }
  end

  context 'link not present' do
    let(:data) { { 'rdf:RDF' => { 'channel' => {} } } }
    it { expect { feed.link }.to raise_error(Yarss::ParseError) }
  end

  context 'link' do
    let(:data) { { 'rdf:RDF' => { 'channel' => { 'link' => 'foo' } } } }
    it { expect(feed.link).to eq('foo') }
  end

  context 'description not present' do
    let(:data) { { 'rdf:RDF' => { 'channel' => {} } } }
    it { expect { feed.description }.to raise_error(Yarss::ParseError) }
  end

  context 'description' do
    let(:data) { { 'rdf:RDF' => { 'channel' => { 'description' => 'Foo' } } } }
    it { expect(feed.description).to eq('Foo') }
  end

  context 'items not present' do
    let(:data) { { 'rdf:RDF' => {} } }
    it { expect { feed.items }.to raise_error(Yarss::ParseError) }
  end

  context 'items' do
    let(:data) do
      {
        'rdf:RDF' => {
          'item' => [
            {
              'rdf:about'   => 'foo',
              'title'       => 'Foo',
              'dc:date'     => '2016-02-02T15:27:00+01:00',
              'link'        => 'http://foo.bar/',
              'dc:creator'  => 'Foo',
              'description' => 'Foo, Bar!'
            }
          ]
        }
      }
    end

    it { expect(feed.items.size).to eq(1) }
  end

  context 'items' do
    let(:data) do
      {
        'rdf:RDF' => {
          'item' => {
            'rdf:about'   => 'foo',
            'title'       => 'Foo',
            'dc:date'     => '2016-02-02T15:27:00+01:00',
            'link'        => 'http://foo.bar/',
            'dc:creator'  => 'Foo',
            'description' => 'Foo, Bar!'
          }
        }
      }
    end

    it { expect(feed.items.size).to eq(1) }
  end
end
