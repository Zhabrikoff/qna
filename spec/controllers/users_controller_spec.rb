# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #show' do
    before do
      login(user)

      get :show, params: { id: user }
    end

    it 'renders show template' do
      expect(response).to render_template :show
    end
  end
end
