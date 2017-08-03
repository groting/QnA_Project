require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  
  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }
    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }
    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do

      it 'associates question with the user' do
        expect { post :create, params: { question: attributes_for(:question) } }
          .to change(@user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }
          .to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let!(:users_question) { create(:question, user: @user) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: users_question,
          question: attributes_for(:question) }, format: :js
        expect(assigns(:question)).to eq users_question
      end

      it 'change question attributes' do
        patch :update, params: { id: users_question,
          question: { title: 'new_title', body: 'new_body' } }, format: :js
        users_question.reload
        expect(users_question.title).to eq 'new_title'
        expect(users_question.body).to eq 'new_body'
      end

      it 'redirects to updated @question' do
        patch :update, params: { id: users_question,
          question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      let(:title) { users_question.title }
      let(:body) { users_question.body }
      before do
        patch :update, params: { id: users_question,
          question: { title: 'new_title', body: nil } }, format: :js
      end
      it 'does not change @question attributes' do
        users_question.reload
        expect(users_question.title).to eq title
        expect(users_question.body).to eq body
      end

      it 're-renders edit view' do
        expect(response).to render_template :update
      end
    end

    context 'user tries to update question that does not belong to him' do
      let(:title) { question.title }
      let(:body) { question.body }
      before do
        patch :update, params: { id: question,
          question: { title: 'new_title', body: 'new_body' } }, format: :js
      end
      it 'does not update question attributes' do
        question.reload
        expect(question.title).to eq title
        expect(question.body).to eq body
      end

      it 'returns 403 status' do
        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let!(:users_question) { create(:question, user: @user) }
    before { question }

    context 'author tries to delete question' do
      it 'deletes question' do
        expect { delete :destroy, params: { id: users_question } }
          .to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: users_question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'user tries to delete question that does not belongs to him' do
      it 'does not deletes question' do
        expect { delete :destroy, params: { id: question } }
          .to_not change(Question, :count)
      end

      it 'redirects to questions index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end
  end
  it_behaves_like 'voted'
  it_behaves_like 'commented', :question
end
