# frozen_string_literal: true

describe Yarss::Atom::ItemParser do
  let(:item) { described_class.new(data) }
  let(:data) { {} }

  context 'parse raises Yarss::ParseError' do
    it { expect { item.parse }.to raise_error(Yarss::ParseError) }
  end

  context 'parse' do
    let(:data) do
      {
        'id'      => 'foo',
        'title'   => 'Foo',
        'updated' => '2016-02-02T15:27:00+01:00',
        'link'    => 'http://foo.bar/',
        'author'  => 'Foo',
        'content' => 'Foo, Bar!'
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
    let(:data) { { 'id' => 'foo' } }
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
    let(:data) { { 'updated' => '2016-02-02T15:27:00+01:00' } }
    let(:day)  { DateTime.parse('2016-02-02T15:27:00+01:00') }
    it { expect(item.updated).to eq(day) }
  end

  context 'updated malformed' do
    let(:data) { { 'updated' => 'xx' } }
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
    it { expect(item.author).to eq('') }
  end

  context 'author' do
    let(:data) { { 'author' => 'Foo' } }
    it { expect(item.author).to eq('Foo') }
  end

  context 'content' do
    let(:data) { { 'content' => 'Foo' } }
    it { expect(item.content).to eq('Foo') }
  end

  context 'summary' do
    let(:data) { { 'summary' => 'Foo' } }
    it { expect(item.content).to eq('Foo') }
  end

  context 'content over summary' do
    let(:data) { { 'summary' => 'Foo', 'content' => 'Bar' } }
    it { expect(item.content).to eq('Bar') }
  end
end
