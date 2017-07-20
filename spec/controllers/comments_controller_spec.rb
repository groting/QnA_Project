require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  let(:commentable) { create(:question) }
  let(:comment) { create(:comment, commentable: commentable) }
  let(:users_comment) { create(:comment, commentable: commentable, user: @user) }

 describe 'DELETE #destroy' do
    context 'author user tries to delete comment' do
      sign_in_user
      it 'deletes comment' do
        users_comment
        expect { delete :destroy, params: { id: users_comment }, format: :js }
          .to change(Comment, :count).by(-1)
      end
    end
    context 'user tries to delete another_users comment' do
      sign_in_user
      it ' does not delete comment' do
        comment
        expect { delete :destroy, params: { id: comment }, format: :js }
          .to_not change(Comment, :count)
      end
    end

    context 'guest tries to delete comment' do
      it ' does not delete comment' do
        comment
        expect { delete :destroy, params: { id: comment }, format: :js }
          .to_not change(Comment, :count)
      end
    end
  end

end