# frozen_string_literal: true

describe Yarss::Rss::ItemParser do
  let(:item) { described_class.new(data) }
  let(:data) { {} }

  context 'parse raises Yarss::ParseError' do
    it { expect { item.parse }.to raise_error(Yarss::ParseError) }
  end

  context 'parse' do
    let(:data) do
      {
        'guid'        => 'foo',
        'title'       => ' Foo ',
        'pubDate'     => 'Tue, 2 Feb 2016 15:27:00 +0100',
        'link'        => 'http://foo.bar/',
        'author'      => 'Foo',
        'description' => 'Foo, Bar!'
      }
    end

    it 'parse' do
      expect(item.parse).to eq(
        Yarss::Item.new(
          id:         'foo',
          title:      'Foo',
          updated_at: DateTime.parse('2016-02-02T15:27:00+01:00'),
          link:       'http://foo.bar/',
          author:     'Foo',
          content:    'Foo, Bar!'
        )
      )
    end
  end

  context 'guid not present' do
    it { expect { item.guid }.to raise_error(Yarss::ParseError) }
  end

  context 'title as guid' do
    let(:data) { { 'title' => 'foo' } }
    it { expect(item.guid).to eq('acbd18db4cc2f85cedef654fccc4a4d8') }
  end

  context 'guid' do
    let(:data) { { 'guid' => 'foo' } }
    it { expect(item.guid).to eq('foo') }
  end

  context 'title not present' do
    it { expect { item.title }.to raise_error(Yarss::ParseError) }
  end

  context 'guid as title' do
    let(:data) { { 'guid' => 'foo' } }
    it { expect(item.title).to eq('foo') }
  end

  context 'title' do
    let(:data) { { 'title' => ' Foo ' } }
    it { expect(item.title).to eq('Foo') }
  end

  context 'pubDate not present' do
    it { expect(item.pub_date).to be_a(DateTime) }
  end

  context 'pubDate' do
    let(:data) { { 'pubDate' => 'Tue, 2 Feb 2016 15:27:00 +0100' } }
    let(:day)  { DateTime.parse('2016-02-02T15:27:00+01:00') }
    it { expect(item.pub_date).to eq(day) }
  end

  context 'pubDate malformed' do
    let(:data) { { 'pubDate' => 'xx' } }
    it { expect { item.pub_date }.to raise_error(Yarss::ParseError) }
  end

  context 'link not present' do
    it { expect { item.link }.to raise_error(Yarss::ParseError) }
  end

  context 'link' do
    let(:data) { { 'link' => 'http://foo.bar/' } }
    it { expect(item.link).to eq('http://foo.bar/') }
  end

  context 'author not present' do
    it { expect(item.author).to eq('') }
  end

  context 'author' do
    let(:data) { { 'author' => 'Foo' } }
    it { expect(item.author).to eq('Foo') }
  end

  context 'author' do
    let(:data) { { 'dc:creator' => 'Foo' } }
    it { expect(item.author).to eq('Foo') }
  end

  context 'author' do
    let(:data) { { 'creator' => 'Foo' } }
    it { expect(item.author).to eq('Foo') }
  end

  context 'description not present' do
    it { expect(item.description).to eq('') }
  end

  context 'description' do
    let(:data) { { 'description' => 'Foo, Bar!' } }
    it { expect(item.description).to eq('Foo, Bar!') }
  end

  context 'description' do
    let(:data) { { 'description' => '', 'content:encoded' => 'Foo, Bar!' } }
    it { expect(item.description).to eq('Foo, Bar!') }
  end
end
