# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many :answers }
  it { should have_many :links }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it { should have_many_attached(:files) }

  describe '#add_award_to_user' do
    let(:user) { create(:user) }
    let(:question) { create(:question, :with_award) }
    let(:award) { question.award }

    context 'add award to user' do
      before do
        question.add_award_to_user(user)
      end

      it { expect(award).to eq(user.awards.first) }
    end
  end
end
