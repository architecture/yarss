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
        { 'href' => 'foo' }
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

  context 'absolutize_urls' do
    let(:broken) do
      <<-EOS
        <p>Hello!</p>
        <p>
          <a href="/cats/gorbachev" title="Gorbachev"><img src="/img/cat.jpg" alt="Gorbachev" /></a>,
          <a href='/cats/gorbachev'><img src='/img/cat.jpg'/></a>,
          <a href="http://foo.bar/cats/xx"><img src="http://foo.bar/img/xx.jpg"></a>,
          <a href="//foo.bar/cats/xx"><img src="foo.bar/img/xx.jpg"></a>,
          <a href="/cats/puff"><img src="/img/puff.jpg"></a>.
          <a href="/"><img src="/"></a>.
        </p>
        <p>Bye!</p>
      EOS
    end

    let(:fixed) do
      <<-EOS
        <p>Hello!</p>
        <p>
          <a href="http://foo.bar/cats/gorbachev" title="Gorbachev"><img src="http://foo.bar/img/cat.jpg" alt="Gorbachev" /></a>,
          <a href='http://foo.bar/cats/gorbachev'><img src='http://foo.bar/img/cat.jpg'/></a>,
          <a href="http://foo.bar/cats/xx"><img src="http://foo.bar/img/xx.jpg"></a>,
          <a href="//foo.bar/cats/xx"><img src="foo.bar/img/xx.jpg"></a>,
          <a href="http://foo.bar/cats/puff"><img src="http://foo.bar/img/puff.jpg"></a>.
          <a href="http://foo.bar/"><img src="http://foo.bar/"></a>.
        </p>
        <p>Bye!</p>
      EOS
    end

    it 'no base' do
      expect(described_class.absolutize_urls(broken, '')).to eq(broken)
    end

    it 'no content' do
      expect(described_class.absolutize_urls('', 'x')).to eq('')
    end

    it 'works' do
      base = 'http://foo.bar/'
      expect(described_class.absolutize_urls(broken, base)).to eq(fixed)
    end

    it 'works' do
      base = 'http://foo.bar'
      expect(described_class.absolutize_urls(broken, base)).to eq(fixed)
    end
  end
end
