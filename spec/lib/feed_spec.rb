# frozen_string_literal: true

describe Yarss::Feed do
  context 'Full item' do
    let(:item) do
      described_class.new(
        title:       'Title',
        link:        'Link',
        description: 'Description',
        items:       [Yarss::Item.new]
      )
    end

    it { expect(item.title).to eq('Title') }
    it { expect(item.title?).to eq(true) }

    it { expect(item.link).to eq('Link') }
    it { expect(item.link?).to eq(true) }

    it { expect(item.description).to eq('Description') }
    it { expect(item.description?).to eq(true) }

    it { expect(item.items).to eq([Yarss::Item.new]) }
    it { expect(item.items?).to eq(true) }
  end

  context 'Nil item' do
    let(:item) { described_class.new }

    it { expect(item.title).to eq(nil) }
    it { expect(item.title?).to eq(false) }

    it { expect(item.link).to eq(nil) }
    it { expect(item.link?).to eq(false) }

    it { expect(item.description).to eq(nil) }
    it { expect(item.description?).to eq(false) }

    it { expect(item.items).to eq(nil) }
    it { expect(item.items?).to eq(false) }
  end

  context 'Empty item' do
    let(:item) do
      described_class.new(
        title:       '',
        link:        '',
        description: '',
        items:       []
      )
    end

    it { expect(item.title).to eq('') }
    it { expect(item.title?).to eq(false) }

    it { expect(item.link).to eq('') }
    it { expect(item.link?).to eq(false) }

    it { expect(item.description).to eq('') }
    it { expect(item.description?).to eq(false) }

    it { expect(item.items).to eq([]) }
    it { expect(item.items?).to eq(false) }
  end
end
