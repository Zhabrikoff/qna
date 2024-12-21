# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, :with_file, question: question, user: user) }
  let(:file) { answer.files.first }

  describe 'DELETE #destroy' do
    before do
      login(user)
    end

    context 'when file exists' do
      it 'removes file from db' do
        expect do
          delete :destroy, params: { id: file.id }, format: :js
        end.to change(ActiveStorage::Attachment, :count).by(-1)
      end
    end

    context 'when file doesn\'t exist' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect do
          delete :destroy, params: { id: 'test_id' }, format: :js
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
