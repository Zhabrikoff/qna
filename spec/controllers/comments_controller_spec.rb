# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:comment) { create(:comment, commentable: question, user: user) }

  before do
    login(user)
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new comment in the database' do
        expect { post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js }.to change(Comment, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js

        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'doesn\'t save the comment' do
        expect { post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid) }, format: :js }.not_to change(Comment, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid) }, format: :js

        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:comment) { create(:comment, commentable: question) }

    it 'deletes the comment' do
      expect { delete :destroy, params: { id: comment }, format: :js }.to change(Comment, :count).by(-1)
    end

    it 'redirects to question show template' do
      delete :destroy, params: { id: comment }, format: :js

      expect(response).to render_template :destroy
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'changes comment attributes' do
        patch :update, params: { id: comment, question_id: question, comment: { body: 'edited comment' } }, format: :js

        comment.reload

        expect(comment.body).to eq 'edited comment'
      end

      it 'renders updated view' do
        patch :update, params: { id: comment, question_id: question, comment: { body: 'edited comment' } }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'doesn\'t change comment attributes' do
        expect { patch :update, params: { id: comment, question_id: question, comment: attributes_for(:comment, :invalid) }, format: :js }.not_to change(comment, :body)
      end

      it 'renders edit template' do
        patch :update, params: { id: comment, question_id: question, comment: attributes_for(:comment, :invalid) }, format: :js

        expect(response).to render_template :update
      end
    end
  end
end
