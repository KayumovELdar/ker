require 'rails_helper'
require Rails.root.join "spec/support/shared/api_authorization.rb"

describe 'Profiles API', type: :request do
  let(:headers) {  { "CONTENT_TYPE" => "application/json",
                     "ACCEPT" => 'application/json' } }
  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }
    let(:method) { :get }
    it_behaves_like 'API Authorizable' do

    end

    context 'authorized' do

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end
  describe 'GET /api/v1/profiles/index' do
    let(:api_path) { '/api/v1/profiles' }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let!(:users) { create_list(:user, 5) }

      before { get api_path, params: { access_token: access_token.token } , headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of others profile' do
        expect(json['users'].size).to eq 5
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['users'].first[attr]).to eq users.first.send(attr).as_json
        end
      end

      it 'does not returns private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['users'].first).to_not have_key(attr)
        end
      end
    end
  end
end
