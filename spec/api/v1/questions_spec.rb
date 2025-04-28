# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:question_response) { json['questions'].first }

      before do
        do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq questions.size
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq(3)
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comments) { create_list(:comment, 3, commentable: question) }
      let!(:links) { create_list(:link, 3, linkable: question) }
      let!(:files) do
        question.files.attach(
          io: Rails.root.join('spec/rails_helper.rb').open,
          filename: 'rails_helper.rb'
        )
        question.files.attach(
          io: Rails.root.join('spec/spec_helper.rb').open,
          filename: 'spec_helper.rb'
        )
      end

      let(:question_response) { json['question'] }

      before do
        do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains associated comments' do
        expect(question_response['comments'].size).to eq comments.size
      end

      it 'contains associated links' do
        expect(question_response['links'].size).to eq links.size
      end

      it 'contains associated files' do
        expect(question_response['files'].size).to eq question.files.count
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq user.id
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:method) { :post }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:question_response) { json['question'] }

      context 'with valid attributes' do
        before do
          post(api_path, params: { access_token: access_token.token, question: { title: 'New title', body: 'New body' } })
        end

        it 'returns question' do
          expect(question_response['title']).to eq 'New title'
          expect(question_response['body']).to eq 'New body'
          expect(question_response['user']['id']).to eq user.id
        end
      end

      context 'with invalid attributes' do
        before do
          post(api_path, params: { access_token: access_token.token, question: { title: nil, body: nil } })
        end

        it 'returns errors' do
          expect(json['errors']).to eq ["Title can't be blank", "Body can't be blank"]
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :patch }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:question_response) { json['question'] }

      context 'with valid attributes' do
        before do
          patch(api_path, params: { access_token: access_token.token, question: { title: 'Updated title', body: 'Updated body' } })
        end

        it 'returns updated question' do
          expect(question_response['title']).to eq 'Updated title'
          expect(question_response['body']).to eq 'Updated body'
          expect(question_response['user']['id']).to eq user.id
        end
      end

      context 'with invalid attributes' do
        before do
          patch(api_path, params: { access_token: access_token.token, question: { title: nil, body: nil } })
        end

        it 'returns errors' do
          expect(json['errors']).to eq ["Title can't be blank", "Body can't be blank"]
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :delete }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      it 'deletes question' do
        expect { delete api_path, params: { access_token: access_token.token } }
          .to change(Question, :count).by(-1)
      end

      it 'returns 200 status' do
        delete api_path, params: { access_token: access_token.token }

        expect(response).to be_successful
      end
    end
  end
end
