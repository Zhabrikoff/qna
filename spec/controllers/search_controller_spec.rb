# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #search' do
    it 'renders search template' do
      get :search

      expect(response).to render_template :search
    end

    it 'global search' do
      ThinkingSphinx::Test.run do
        get :search, params: { query: 'test' }
      end
    end

    it 'search in model' do
      ThinkingSphinx::Test.run do
        get :search, params: { query: 'test', model: 'Question' }
      end
    end
  end
end
