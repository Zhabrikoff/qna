# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:another_answer) { create(:answer, question:) }

  describe 'POST #create' do
    before do
      login(user)
    end

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(Answer, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }

        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.not_to change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }

        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      login(user)
    end

    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    it 'deletes the answer' do
      expect { delete :destroy, params: { question_id: question, id: answer }, format: :js }.to change(Answer, :count).by(-1)
    end

    it 'renders question show template' do
      delete :destroy, params: { question_id: question, id: answer }, format: :js

      expect(response).to render_template :destroy
    end
  end

  describe 'PATCH #update' do
    before do
      login(user)
    end

    let!(:answer) { create(:answer, question: question) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'New body' } }, format: :js

        answer.reload

        expect(answer.body).to eq 'New body'
      end

      it 'renders update template' do
        patch :update, params: { id: answer, answer: { body: 'New body' } }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'doesn\'t change answer attributes' do
        expect do
          patch(:update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js)
        end.to_not change(answer, :body)
      end

      it 'renders update template' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js

        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #mark_as_best' do
    before do
      login(user)
    end

    it 'marks the answer as the best' do
      patch :mark_as_best, params: { id: answer, question_id: question }, format: :js

      answer.reload

      expect(answer).to be_best
    end

    it 'renders mark_as_best template' do
      patch :mark_as_best, params: { id: answer, question_id: question }, format: :js

      expect(response).to render_template :mark_as_best
    end

    it 'makes another answer the best' do
      patch :mark_as_best, params: { id: answer, question_id: question }, format: :js
      patch :mark_as_best, params: { id: another_answer, question_id: question }, format: :js

      another_answer.reload
      answer.reload

      expect(another_answer).to be_best
      expect(answer).to_not be_best
    end
  end

  describe 'DELETE #delete_file' do
    before do
      login(user)
    end

    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, :with_file, question: question) }
    let!(:file) { answer.files.first }

    it 'deletes the file' do
      expect { delete :delete_file, params: { id: answer, file_id: file.id }, format: :js }.to change(answer.files, :count).by(-1)
    end

    it 'renders delete_file template' do
      delete :delete_file, params: { id: answer, file_id: file.id }, format: :js

      expect(response).to render_template :delete_file
    end
  end
end
