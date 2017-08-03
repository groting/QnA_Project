shared_examples_for 'voted' do


  describe 'PATCH #like' do
    sign_in_user
    let(:resource) { controller.controller_name.singularize.to_sym }
    let(:votable) { create(resource) }
    let(:users_votable) { create(resource, user: @user) }

    context 'user tries to like resource' do
      it 'set like to resource' do
        expect { patch :like, params: { id: votable, vote: :like },
          format: :json }.to change(Vote, :count).by(1)
      end

      it 'increases rating by 1' do
        patch :like, params: { id: votable, vote: :like }, format: :json
        votable.reload
        expect(votable.rating).to eq 1
      end
    end

    context 'user tries to like resource once more time' do
      it 'set like to resource' do
        patch :like, params: { id: votable, vote: :like }, format: :json
        expect { patch :like, params: { id: votable, vote: :like },
          format: :json }.to_not change(Vote, :count)
      end

      it 'does not increases rating' do
        patch :like, params: { id: votable, vote: :like }, format: :json
        patch :like, params: { id: votable, vote: :like }, format: :json
        votable.reload
        expect(votable.rating).to eq 1
      end
    end

    context 'author tries to like his resource' do
      it 'does not set like to resource' do
        expect { patch :like, params: { id: users_votable, vote: :like }, format: :json }
          .to_not change(Vote, :count)
      end

      it 'does not increases rating' do
        patch :like, params: { id: users_votable, vote: :like }, format: :json
        votable.reload
        expect(votable.rating).to eq 0
      end

      it 'returns 403 status' do
        patch :like, params: { id: users_votable, vote: :like }, format: :json
        expect(response).to have_http_status(403)
      end

      it 'returns error message' do
        patch :like, params: { id: users_votable, vote: :like }, format: :json
        expect(JSON(response.body)["error"])
          eq("You do not have permission to vote for this #{controller.controller_name.singularize}")
      end
    end
  end

  describe 'PATCH #dislike' do
    sign_in_user
    let(:resource) { controller.controller_name.singularize.to_sym }
    let(:votable) { create(resource) }
    let(:users_votable) { create(resource, user: @user) }

    context 'user tries to dislike resource' do
      it 'set dislike to resource' do
        expect { patch :dislike, params: { id: votable, vote: :dislike },
          format: :json }.to change(Vote, :count).by(1)
      end

      it 'decreases rating by 1' do
        patch :dislike, params: { id: votable, vote: :dislike }, format: :json
        votable.reload
        expect(votable.rating).to eq -1
      end
    end

    context 'user tries to dislike resource once more time' do
      it 'set dislike to resource' do
        patch :dislike, params: { id: votable, vote: :dislike }, format: :json
        expect { patch :dislike, params: { id: votable, vote: :dislike },
          format: :json }.to_not change(Vote, :count)
      end

      it 'does not decreases rating' do
        patch :dislike, params: { id: votable, vote: :dislike }, format: :json
        patch :dislike, params: { id: votable, vote: :dislike }, format: :json
        votable.reload
        expect(votable.rating).to eq -1
      end
    end

    context 'author tries to dislike his resource' do
      it 'does not set dislike to resource' do
        expect { patch :dislike, params: { id: users_votable, vote: :dislike }, format: :json }
          .to_not change(Vote, :count)
      end

      it 'does not decreases rating' do
        patch :dislike, params: { id: users_votable, vote: :dislike }, format: :json
        votable.reload
        expect(votable.rating).to eq 0
      end

      it 'returns 403 status' do
        patch :dislike, params: { id: users_votable, vote: :dislike }, format: :json
        expect(response).to have_http_status(403)
      end

      it 'returns error message' do
        patch :dislike, params: { id: users_votable, vote: :dislike }, format: :json
        expect(JSON(response.body)["error"])
          eq("You do not have permission to vote for this #{controller.controller_name.singularize}")
      end
    end
  end

  describe 'PATCH #clear_vote' do
    sign_in_user
    let(:resource) { controller.controller_name.singularize.to_sym }
    let(:votable) { create(resource) }
    let(:users_votable) { create(resource, user: @user) }

    context 'user tries to clear_vote' do
      it 'delete vote from resource' do
        patch :dislike, params: { id: votable, vote: :dislike }, format: :json
        expect { patch :clear_vote, params: { id: votable, vote: :clear_vote},
          format: :json }.to change(Vote, :count).by(-1)
      end
    end

    context 'user tries to clear_vote resource once more time' do
      it 'clear_vote from resource' do
        patch :dislike, params: { id: votable, vote: :dislike }, format: :json
        patch :clear_vote, params: { id: votable, vote: :clear_vote }, format: :json
        expect { patch :clear_vote, params: { id: votable, vote: :clear_vote },
          format: :json }.to_not change(Vote, :count)
      end

      it 'does not change rating' do
        patch :dislike, params: { id: votable, vote: :dislike }, format: :json
        patch :clear_vote, params: { id: votable, vote: :clear_vote }, format: :json
        patch :clear_vote, params: { id: votable, vote: :clear_vote }, format: :json
        votable.reload
        expect(votable.rating).to eq 0
      end
    end
  end
end