require 'rails_helper'

shared_examples_for 'votable' do
  let(:model) { described_class }

  let(:user) { create(:user) }
  let(:votable) { create(model.to_s.underscore.to_sym) }

  describe '#like' do
    it 'should set like to votable' do
      votable.like(user)
      expect(Vote.last.value).to eq 1
    end

    it 'should increase votables rating' do
      votable.like(user)
      expect(votable.rating).to eq 1
    end
  end

  describe '#dislike' do
    it 'should set dislike to votable' do
      votable.dislike(user)
      expect(Vote.last.value).to eq -1
    end

    it 'should decrease votables rating' do
      votable.dislike(user)
      expect(votable.rating).to eq -1
    end
  end

  describe '#clear_vote' do
    it 'should clear users vote' do
      votable.dislike(user)
      expect { votable.clear_vote(user) }.to change(votable.votes, :count).by(-1)
    end
  end
end