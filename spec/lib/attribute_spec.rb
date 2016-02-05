# frozen_string_literal: true

describe Yarss::Attribute do
  context 'value' do
    it 'String' do
      expect(described_class.value('foo')).to eq('foo')
    end

    it 'Hash' do
      value = {
        '__content__' => 'foo'
      }

      expect(described_class.value(value)).to eq('foo')
    end

    it 'Hash error' do
      expect { described_class.value({}) }.to raise_error(Yarss::ParseError)
    end

    it '42' do
      expect { described_class.value(42) }.to raise_error(Yarss::ParseError)
    end
  end

  context 'author_value' do
    it 'String' do
      expect(described_class.author_value('foo')).to eq('foo')
    end

    it 'Hash' do
      value = {
        'name' => 'foo'
      }

      expect(described_class.author_value(value)).to eq('foo')
    end

    it 'Hash error' do
      expect { described_class.author_value({}) }
        .to raise_error(Yarss::ParseError)
    end

    it '42' do
      expect { described_class.author_value(42) }
        .to raise_error(Yarss::ParseError)
    end
  end

  context 'link_value' do
    it 'String' do
      expect(described_class.link_value('foo')).to eq('foo')
    end

    it 'Hash' do
      value = {
        'href' => 'foo'
      }

      expect(described_class.link_value(value)).to eq('foo')
    end

    it 'Hash error' do
      expect { described_class.link_value({}) }
        .to raise_error(Yarss::ParseError)
    end

    it '42' do
      expect { described_class.link_value(42) }
        .to raise_error(Yarss::ParseError)
    end

    it 'Array' do
      value = [
        { 'rel' => 'self', 'href' => 'foo' }
      ]

      expect(described_class.link_value(value)).to eq('foo')
    end

    it 'Array' do
      value = [
        { 'rel' => 'alternate', 'href' => 'foo' }
      ]

      expect(described_class.link_value(value)).to eq('foo')
    end

    it 'Array' do
      value = [
        'foo',
        { 'rel' => 'alternate', 'href' => 'foo' }
      ]

      expect(described_class.link_value(value)).to eq('foo')
    end

    it 'Array error' do
      value = [
        { 'rel' => 'self' }
      ]

      expect { described_class.link_value(value) }
        .to raise_error(Yarss::ParseError)
    end

    it 'Array error' do
      expect { described_class.link_value([]) }
        .to raise_error(Yarss::ParseError)
    end
  end
end
