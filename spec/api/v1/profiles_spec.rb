require 'rails_helper'

describe 'Profile API' do
  let(:me) { create(:user) }
  let!(:users) { create_list(:user, 3) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe 'GET #me' do

    it_behaves_like 'API unauthenticated' do
      let(:path) { '/api/v1/profiles/me' }
      let(:method) { :get }
    end

    context 'authorized' do

      before { get '/api/v1/profiles/me', as: :json, params: {access_token: access_token.token} }

      it 'returns status 200' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET #index' do

    it_behaves_like 'API unauthenticated' do
      let(:path) { '/api/v1/profiles' }
      let(:method) { :get }
    end

    context 'authorized' do
      before { get '/api/v1/profiles', as: :json, params: {access_token: access_token.token} }

      it 'returns status 200' do
        expect(response).to be_success
      end

      it 'returns array of users' do
        expect(response.body).to be_eql users.to_json
      end
    end
  end
end