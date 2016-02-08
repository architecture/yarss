# frozen_string_literal: true

describe Yarss::Item do
  context 'Full item' do
    let(:item) do
      described_class.new(
        id:         'ID',
        title:      'Title',
        updated_at: DateTime.now,
        link:       'Link',
        author:     'Author',
        content:    'Content'
      )
    end

    it { expect(item.id).to eq('ID') }
    it { expect(item.id?).to eq(true) }

    it { expect(item.title).to eq('Title') }
    it { expect(item.title?).to eq(true) }

    it { expect(item.updated_at).to be_a(DateTime) }
    it { expect(item.updated_at?).to eq(true) }

    it { expect(item.link).to eq('Link') }
    it { expect(item.link?).to eq(true) }

    it { expect(item.author).to eq('Author') }
    it { expect(item.author?).to eq(true) }

    it { expect(item.content).to eq('Content') }
    it { expect(item.content?).to eq(true) }
  end

  context 'Nil item' do
    let(:item) { described_class.new }

    it { expect(item.id).to eq(nil) }
    it { expect(item.id?).to eq(false) }

    it { expect(item.title).to eq(nil) }
    it { expect(item.title?).to eq(false) }

    it { expect(item.updated_at).to eq(nil) }
    it { expect(item.updated_at?).to eq(false) }

    it { expect(item.link).to eq(nil) }
    it { expect(item.link?).to eq(false) }

    it { expect(item.author).to eq(nil) }
    it { expect(item.author?).to eq(false) }

    it { expect(item.content).to eq(nil) }
    it { expect(item.content?).to eq(false) }
  end

  context 'Empty item' do
    let(:item) do
      described_class.new(
        id:         '',
        title:      '',
        updated_at: nil,
        link:       '',
        author:     '',
        content:    ''
      )
    end

    it { expect(item.id).to eq('') }
    it { expect(item.id?).to eq(false) }

    it { expect(item.title).to eq('') }
    it { expect(item.title?).to eq(false) }

    it { expect(item.updated_at).to eq(nil) }
    it { expect(item.updated_at?).to eq(false) }

    it { expect(item.link).to eq('') }
    it { expect(item.link?).to eq(false) }

    it { expect(item.author).to eq('') }
    it { expect(item.author?).to eq(false) }

    it { expect(item.content).to eq('') }
    it { expect(item.content?).to eq(false) }
  end
end
