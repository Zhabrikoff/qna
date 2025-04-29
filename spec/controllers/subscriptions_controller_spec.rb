# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    before do
      sign_in user
    end

    it 'creates a subscription' do
      expect { post :create, params: { question_id: question.id }, format: :js }.to change(question.subscriptions, :count).by(1)
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:subscription) { create(:subscription, question: question, user: user) }

    before do
      sign_in user
    end

    it 'deletes a subscription' do
      expect { delete :destroy, params: { id: subscription.id }, format: :js }.to change(Subscription, :count).by(-1)
    end
  end
end
