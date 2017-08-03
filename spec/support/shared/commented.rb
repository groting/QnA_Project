shared_examples_for 'commented' do |resource|

  let(:commentable) { create(resource) }
  let(:commentable_id) { "#{resource}_id".to_sym }
  let(:comment) { create(:comment, commentable: commentable) }

  describe 'POST #create_comment' do

    context 'authorized user' do
    sign_in_user

      context 'with valid attributes' do
        it 'associates comment with the user' do
          expect { post :create_comment, params: { id: commentable.id,
                  comment: attributes_for(:comment) }, format: :js }
                  .to change(@user.comments, :count).by(1)
        end

        it 'associates comment with the commentable' do
          expect { post :create_comment, params: { id: commentable.id,
                   comment: attributes_for(:comment) }, format: :js  }
                   .to change(commentable.comments, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the comment' do
          expect { post :create_comment, params: { id: commentable.id,
            comment: attributes_for(:invalid_comment) }, format: :js }
            .to_not change(Comment, :count)
        end
      end
    end
  end

  context 'unauthenticated user tries to create comment' do
    it 'does not creates comment' do
      expect { post :create_comment, params: { id: commentable.id,
               comment: attributes_for(:comment) }, format: :js }
               .to change(commentable.comments, :count).by(0)
    end
  end
end