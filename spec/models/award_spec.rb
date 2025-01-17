# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Award, type: :model do
  it { should belong_to(:user).optional }
  it { should belong_to(:question) }

  it { should validate_presence_of(:name) }

  describe 'validations' do
    let(:question) { create(:question) }
    let(:award) { build(:award, question:) }

    it 'is valid with an attached image' do
      award.image.attach(io: File.open(Rails.root.join('spec/auxiliary/award.png')), filename: 'award.png', content_type: 'image/png')

      expect(award).to be_valid
    end

    it 'is invalid with an incorrect image type' do
      award.image.attach(io: File.open(Rails.root.join('spec/auxiliary/award.svg')), filename: 'award.svg', content_type: 'image/svg')

      expect(award).to_not be_valid
      expect(award.errors[:image]).to include('should be a PNG, JPG or JPEG file')
    end

    it 'is valid without an image' do
      award.image = nil

      expect(award).to be_valid
    end
  end
end
