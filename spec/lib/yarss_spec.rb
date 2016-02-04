# frozen_string_literal: true

describe Yarss do
  it 'new io' do
    feed = described_class.new(File.open('spec/data/feed.rss', 'rb'))
    expect(feed.title).to eq('Ma Feed')
  end

  it 'new file' do
    feed = described_class.new('spec/data/feed.rss')
    expect(feed.title).to eq('Ma Feed')
  end

  it 'from_io' do
    feed = described_class.from_io(File.open('spec/data/feed.rss', 'rb'))
    expect(feed.title).to eq('Ma Feed')
  end

  it 'from_io' do
    feed = described_class.from_io(Pathname.new('spec/data/feed.rss'))
    expect(feed.title).to eq('Ma Feed')
  end

  it 'from_file' do
    feed = described_class.from_file('spec/data/feed.rss')
    expect(feed.title).to eq('Ma Feed')
  end

  context 'from_string' do
    it 'rss' do
      data = File.read('spec/data/feed.rss')
      feed = described_class.from_string(data)
      expect(feed.title).to eq('Ma Feed')
    end

    it 'rss' do
      data = File.read('spec/data/feed.rss')
      feed = described_class.from_string(data, nil)
      expect(feed.title).to eq('Ma Feed')
    end

    it 'atom' do
      data = File.read('spec/data/feed.atom')
      feed = described_class.from_string(data, nil)
      expect(feed.title).to eq('Ma Feed')
    end

    it 'unknown parser' do
      data = String.new('')
      expect { described_class.from_string(data, 'foo') }
        .to raise_error(Yarss::UnknownParserError)
    end

    it 'parse error' do
      data = String.new('hi')
      expect { described_class.from_string(data, nil) }
        .to raise_error(Yarss::ParseError)
    end
  end
end
