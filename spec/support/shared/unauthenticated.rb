shared_examples_for 'API unauthenticated' do
  context 'unauthenticated' do
    it 'returns 401 status if there is no access_token' do
      request_to_resource method, path
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      request_to_resource method, path, access_token: '12345'
      expect(response.status).to eq 401
    end
  end
  def request_to_resource(method, path, options = {})
    send(method, path, as: :json, params: options)
  end
end