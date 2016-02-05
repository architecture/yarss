# frozen_string_literal: true

describe Yarss::Rdf::ItemParser do
  let(:item) { described_class.new(data) }
  let(:data) { {} }

  context 'parse raises Yarss::ParseError' do
    it { expect { item.parse }.to raise_error(Yarss::ParseError) }
  end

  context 'parse' do
    let(:data) do
      {
        'rdf:about'   => 'foo',
        'title'       => 'Foo',
        'dc:date'     => '2016-02-02T15:27:00+01:00',
        'link'        => 'http://foo.bar/',
        'dc:creator'  => 'Foo',
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

  context 'id not present' do
    it { expect { item.id }.to raise_error(Yarss::ParseError) }
  end

  context 'id' do
    let(:data) { { 'rdf:about' => 'foo' } }
    it { expect(item.id).to eq('foo') }
  end

  context 'id' do
    let(:data) { { 'about' => 'foo' } }
    it { expect(item.id).to eq('foo') }
  end

  context 'title not present' do
    it { expect { item.title }.to raise_error(Yarss::ParseError) }
  end

  context 'title' do
    let(:data) { { 'title' => 'Foo' } }
    it { expect(item.title).to eq('Foo') }
  end

  context 'updated not present' do
    it { expect { item.updated }.to raise_error(Yarss::ParseError) }
  end

  context 'updated' do
    let(:data) { { 'dc:date' => '2016-02-02T15:27:00+01:00' } }
    let(:day)  { DateTime.parse('2016-02-02T15:27:00+01:00') }
    it { expect(item.updated).to eq(day) }
  end

  context 'updated' do
    let(:data) { { 'date' => '2016-02-02T15:27:00+01:00' } }
    let(:day)  { DateTime.parse('2016-02-02T15:27:00+01:00') }
    it { expect(item.updated).to eq(day) }
  end

  context 'updated malformed' do
    let(:data) { { 'dc:date' => 'xx' } }
    it { expect { item.updated }.to raise_error(Yarss::ParseError) }
  end

  context 'link not present' do
    it { expect { item.link }.to raise_error(Yarss::ParseError) }
  end

  context 'link' do
    let(:data) { { 'link' => 'foo' } }
    it { expect(item.link).to eq('foo') }
  end

  context 'author not present' do
    it { expect { item.author }.to raise_error(Yarss::ParseError) }
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
    it { expect { item.description }.to raise_error(Yarss::ParseError) }
  end

  context 'description' do
    let(:data) { { 'description' => 'Foo, Bar!' } }
    it { expect(item.description).to eq('Foo, Bar!') }
  end
end
