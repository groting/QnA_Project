require 'rails_helper'
require_relative 'concerns/voted.rb'
require_relative 'concerns/commented.rb'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #create' do
    sign_in_user
    before { question }
    context 'with valid attributes' do

      it 'associates answer with the user' do
        expect { post :create, params: { question_id: question,
                 answer: attributes_for(:answer) }, format: :js }
          .to change(@user.answers, :count).by(1)
      end

      it 'associates answer with the question' do
        expect { post :create, params: { question_id: question,
                 answer: attributes_for(:answer) }, format: :js  }
          .to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { question_id: question,
                                answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question,
                 answer: attributes_for(:invalid_answer) }, format: :js }
          .to_not change(Answer, :count)
      end

      it 'renders to question show view' do
        post :create, params: { question_id: question,
                                answer: attributes_for(:invalid_answer) }, format: :js
        expect(response).to render_template('answers/create')
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let!(:users_answer) { create(:answer, user: @user, question_id: question.id) }

    before { answer }

    context 'author tries to delete answer' do
      it 'deletes answer with js' do
        expect { delete :destroy, params: { id: users_answer }, format: :js }
          .to change(Answer, :count).by(-1)
      end

      it 'renders question destroy view when delete with js' do
        delete :destroy, params: { id: users_answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'user tries to deletes answer that does not belongs to him' do
      it 'does not deletes answer' do
        expect { delete :destroy, params: { id: answer } }
          .to_not change(Answer, :count)
      end

      it 'redirects to questions index view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to questions_path
      end

      it 'shows flash message' do
        delete :destroy, params: { id: answer }
        expect(flash[:alert]).to eq('You are not authorized to access this page.')
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let!(:users_answer) { create(:answer, user: @user, question_id: question.id) }

    context 'author tries to update answer' do
      it 'assigns the requested answer to @answer' do
        patch :update, params: { question_id: question, id: users_answer,
          answer: attributes_for(:answer) }, format: :js
        expect(assigns(:answer)).to eq users_answer
      end

      it 'change answer attributes' do
        patch :update, params: { question_id: question, id: users_answer,
          answer: { body: 'new_body' } }, format: :js
        users_answer.reload
        expect(users_answer.body).to eq 'new_body'
      end

      it 'renders update template' do
        patch :update, params: { question_id: question, id: users_answer,
          answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'another user tries to update answer that does not belongs to him' do
      before do
        patch :update, params: { question_id: question, id: answer,
          answer: { body: 'new_body' } }, format: :js
      end
      it 'does not change answer attributes' do
        answer_body = answer.body
        answer.reload

        expect(answer.body).to eq answer_body
      end

      it 'returns 403 status' do
        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'PATCH #select_best' do

    context 'authenticated user' do
      sign_in_user

      context 'author of question' do
        
        let!(:users_question) { create(:question_with_answers, user: @user) }

        it 'set best flag to answer' do
          patch :select_best, params: { id: users_question.answers.first }, format: :js
          expect(assigns(:answer)).to be_best
        end
      end

      context 'another user' do

        let(:question) { create(:question_with_answers) }

        before do
          patch :select_best, params: { id: question.answers.first }, format: :js
        end

        it 'does not set best flag to answer' do
          expect(assigns(:answer)).to_not be_best
        end

        it 'returns 403 status' do
          expect(response).to have_http_status(403)
        end
      end
    end

    context 'unauthenticated user' do

      let(:question) { create(:question_with_answers) }

      before do
        patch :select_best, params: { id: question.answers.first }, format: :js
      end

      it 'does not set best flag to answer' do
        expect(question.answers.first).to_not be_best
      end

      it 'redirects to error page' do
        expect(response.status).to eq(401)
      end
    end
  end
  
  it_behaves_like 'voted'
  it_behaves_like 'commented', :answer
end