require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:question) { create(:question) }
    describe 'POST #create' do
      context 'Authenticated' do
        sign_in_user
        let(:users_question) { create(:question , user: @user) }
        it 'associates subscription with the user' do
          expect { post :create, params: { question_id: question } }
            .to change(@user.subscriptions, :count).by(1)
        end

        it 'associates subscription with the question' do
          expect { post :create, params: { question_id: question } }
            .to change(question.subscriptions, :count).by(1)
        end

        it 'does not create subscription if user alredy hase it' do
          expect { post :create, params: { question_id: users_question } }
            .to_not change(question.subscriptions, :count)
        end
      end

      context 'Unauthenticated' do
        it 'does not creates subdscription' do
          expect { post :create, params: { question_id: question } }
            .to_not change(question.subscriptions, :count)
        end
      end
    end

    describe 'DELETE #destroy' do
      context 'Authenticated' do
        sign_in_user
        it 'deletes users subscription' do
          post :create, params: { question_id: question }
          expect { delete :destroy, params: { id: question.subscriptions.last } }
            .to change(Subscription, :count).by(-1)
        end
      end

      context 'Unauthenticated' do
        it 'does not deletes users subscription' do
          expect { delete :destroy, params: { id: question.subscriptions.first } }
            .to_not change(question.subscriptions, :count)
        end
      end
    end
end
