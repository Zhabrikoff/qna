# frozen_string_literal: true

require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions/:id/answers' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 3, question: question, user: user) }
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].first }

      before do
        do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq answers.size
      end

      it 'returns all public fields' do
        %w[id body user_id created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(answer_response['user']['id']).to eq answer.user.id
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comments) { create_list(:comment, 3, commentable: answer) }
      let!(:links) { create_list(:link, 3, linkable: answer) }
      let!(:files) do
        answer.files.attach(
          io: Rails.root.join('spec/rails_helper.rb').open,
          filename: 'rails_helper.rb'
        )
        answer.files.attach(
          io: Rails.root.join('spec/spec_helper.rb').open,
          filename: 'spec_helper.rb'
        )
      end
      let(:answer_response) { json['answer'] }

      before do
        do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id body user_id created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains associated comments' do
        expect(answer_response['comments'].size).to eq comments.size
      end

      it 'contains associated links' do
        expect(answer_response['links'].size).to eq links.size
      end

      it 'contains associated files' do
        expect(answer_response['files'].size).to eq answer.files.count
      end
    end
  end

  describe 'POST /api/v1/questions/:id/answers' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:method) { :post }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }

      context 'with valid attributes' do
        before do
          post(api_path, params: { access_token: access_token.token, answer: attributes_for(:answer) })
        end

        it 'returns answer' do
          expect(answer_response['id']).to eq Answer.last.id
        end
      end

      context 'with invalid attributes' do
        before do
          post(api_path, params: { access_token: access_token.token, answer: { body: nil } })
        end

        it 'returns errors' do
          expect(json['errors']).to eq ["Body can't be blank"]
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :patch }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }

      context 'with valid attributes' do
        before do
          patch(api_path, params: { access_token: access_token.token, answer: { body: 'Updated body' } })
        end

        it 'returns updated answer' do
          expect(answer_response['body']).to eq 'Updated body'
        end
      end

      context 'with invalid attributes' do
        before do
          patch(api_path, params: { access_token: access_token.token, answer: { body: nil } })
        end

        it 'returns errors' do
          expect(json['errors']).to eq ["Body can't be blank"]
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :delete }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      it 'deletes answer' do
        expect { delete api_path, params: { access_token: access_token.token } }
          .to change(Answer, :count).by(-1)
      end
    end
  end
end
