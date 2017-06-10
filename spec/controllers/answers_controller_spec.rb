require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    before { question }
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)
      end

      it 'redirects to question show view' do
        post :create, params: {question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'new answer created with the right question id' do
        post :create, params: {question_id: question, answer: attributes_for(:answer) }
        expect(assigns(:answer).question).to eq question 
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: {question_id: question, answer: attributes_for(:invalid_answer) } }.to_not change(Answer, :count)
      end

      it 're-renders question show view' do
        post :create, params: {question_id: question, answer: attributes_for(:invalid_answer) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
  end
end
