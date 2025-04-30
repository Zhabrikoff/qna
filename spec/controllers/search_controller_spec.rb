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

    it 'assigns @data' do
      ThinkingSphinx::Test.run do
        get :search, params: { query: 'test', model: 'Question' }

        expect(assigns(:data)).to be_a(ThinkingSphinx::Search)
      end
    end

    it 'assigns @grouped_results' do
      ThinkingSphinx::Test.run do
        get :search, params: { query: 'test', model: 'Question' }

        expect(assigns(:grouped_results)).to be_a(Hash)
      end
    end
  end
end
