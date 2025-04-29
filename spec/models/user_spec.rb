# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:authorizations).dependent(:destroy) }

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

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123') }
    let(:service) { double('FindForOauthService') }

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)

      User.find_for_oauth(auth)
    end
  end

  describe '#subscribed?' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    let(:subscription) { create(:subscription, user: user, question: question) }

    it 'if user is subscribed to a question' do
      expect(user.subscribed?(question)).to be_truthy
    end

    it 'if user is not subscribed to a question' do
      expect(other_user.subscribed?(question)).to be_falsey
    end
  end
end
