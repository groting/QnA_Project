require 'rails_helper'

shared_examples_for 'unauthenticated' do
  context 'unauthenticated' do
    it 'returns 401 status if there is no access_token' do
      request_to_resource
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      request_with_invalid_token
      expect(response.status).to eq 401
    end
  end
end