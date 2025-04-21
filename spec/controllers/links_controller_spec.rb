# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, :with_link, user: user) }
  let!(:link) { question.links.first }

  describe 'DELETE #destroy' do
    before do
      login(user)
    end

    it 'deletes the link' do
      expect { delete :destroy, params: { id: link }, format: :js }.to change(Link, :count).by(-1)
    end

    it 'renders question show template' do
      delete :destroy, params: { id: link }, format: :js

      expect(response).to render_template :destroy
    end
  end
end
