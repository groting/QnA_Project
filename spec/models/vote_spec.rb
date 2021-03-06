require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:votable) }
  it { should belong_to(:user) }

  it { should validate_uniqueness_of(:value).scoped_to(:user_id, :votable_id, :votable_type) }

  describe '#show' do
    let(:question) { create(:question) }
    let(:user) { create(:user) }
    let(:like_vote) { create(:like_vote) }
    let(:dislike_vote) { create(:dislike_vote)}

    it 'should return like' do
      expect(like_vote.show_value).to eq :like
    end

    it 'should return dislike' do
      expect(dislike_vote.show_value).to eq :dislike
    end
  end
end