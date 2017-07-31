require 'rails_helper'

describe 'Profile API' do
  let(:me) { create(:user) }
  let!(:users) { create_list(:user, 3) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe 'GET #me' do

    context 'unauthenticated' do

      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', as: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/me', as: :json, params: {access_token: '1234'}
        expect(response.status).to eq 401
      end
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

  describe 'GET #others' do

    context 'unauthenticated' do

      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/others', as: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/others', as: :json, params: {access_token: '1234'}
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      before { get '/api/v1/profiles/others', as: :json, params: {access_token: access_token.token} }

      it 'returns status 200' do
        expect(response).to be_success
      end

      it 'returns array of users' do
        expect(response.body).to be_eql users.to_json
      end
    end
  end
end