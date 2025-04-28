# frozen_string_literal: true

require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    { 'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token) }
      let(:method) { :get }

      before do
        do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json).to have_key(attr)
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token) }
      let!(:users) { create_list(:user, 3) }

      before do
        do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'return list of users except current user' do
        expect(json.size).to eq users.size

        json.each do |user|
          expect(user['id']).to_not eq me.id
        end
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json.first[attr]).to eq users.first.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json.first).not_to have_key(attr)
        end
      end
    end
  end
end
