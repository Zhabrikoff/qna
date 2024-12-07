# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author?' do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: author) }

    it 'if user is author' do
      expect(author.author?(question)).to be_truthy
    end

    it 'if user isn\'t author' do
      expect(user.author?(question)).to be_falsey
    end
  end
end
