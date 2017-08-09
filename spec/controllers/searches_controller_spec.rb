require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  let(:question) { create(:question, title: 'Test') }

  before { get :show, params: { search: 'Test', resource: 'questions' } }
  describe 'GET #index' do
    it 'assigns resource to @resource' do
      expect(assigns(:resource)).to eq 'questions'
    end

    it 'assigns search to @search_string' do
      expect(assigns(:search_string)).to eq 'Test'
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end
end