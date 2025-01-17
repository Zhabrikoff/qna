# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe '#gist_url?' do
    let(:question) { create(:question) }

    context 'when the url is a valid gist url' do
      let(:link) { create(:link, linkable: question, url: 'https://gist.github.com/test_name/test_id') }

      it 'returns true for a valid gist url' do
        expect(link.gist_url?).to be_truthy
      end
    end

    context 'when the url is not a valid gist url' do
      let(:link) { create(:link, linkable: question, url: 'https://github.com/test') }

      it 'returns false for an invalid gist url' do
        expect(link.gist_url?).to be_falsey
      end
    end
  end
end
