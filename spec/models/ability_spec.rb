require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, :all }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:other_users_question) { create(:question) }
    let(:other_users_answer) { create(:answer, user: other_user) }
    let(:other_answer) { create(:answer, question: create(:question)) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:other_users_question_comment) { create(:comment, commentable: question, user: other_user) }

    before do
      file = File.open("#{Rails.root}/spec/spec_helper.rb")
      question.attachments.create(file: file)
      other_users_question.attachments.create(file: file)
    end

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }

    it { should be_able_to :create_comment, :all }

    it { should be_able_to :update, question, user: user }
    it { should_not be_able_to :update, other_users_question, user: user }
    it { should be_able_to :update, answer, user: user }
    it { should_not be_able_to :update, other_users_answer, user: user }

    it { should be_able_to :destroy, question, user: user}
    it { should_not be_able_to :destroy, other_users_question, user: user }
    it { should be_able_to :destroy, answer, user: user}
    it { should_not be_able_to :destroy, other_users_answer, user: user }

    it { should be_able_to :destroy, create(:comment, commentable: question, user: user), user: user }
    it { should_not be_able_to :destroy, other_users_question_comment, user: user }
    it { should be_able_to :destroy, create(:comment, commentable: answer, user: user), user: user }
    it { should_not be_able_to :destroy, create(:comment, commentable: answer, user: other_user), user: user }

    it { should be_able_to :select_best, create(:answer, question: question, user: other_user), user: user }
    it { should_not be_able_to :select_best, other_answer, user: user }

    it { should be_able_to :like, other_users_question, user: user }
    it { should_not be_able_to :like, question, user: user }

    it { should be_able_to :like, other_users_answer, user: user }
    it { should_not be_able_to :like, answer, user: user }

    it { should be_able_to :dislike, other_users_question, user: user }
    it { should_not be_able_to :dislike, question, user: user }

    it { should be_able_to :dislike, other_users_answer, user: user }
    it { should_not be_able_to :dislike, answer, user: user }

    it { should be_able_to :clear_vote, other_users_question, user: user }
    it { should_not be_able_to :clear_vote, question, user: user }

    it { should be_able_to :clear_vote, other_users_answer, user: user }
    it { should_not be_able_to :clear_vote, answer, user: user }

    it { should be_able_to :destroy, question.attachments.first, user: user }
    it { should_not be_able_to :destroy, other_users_question.attachments.first, user: user }

    it { should be_able_to :me, user: user }
  end
end