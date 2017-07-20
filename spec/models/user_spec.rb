require 'rails_helper'

RSpec.describe User do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:comments) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:user) { create(:user) }
  let(:user_with_questions) { create(:user_with_questions) }

  describe '#author_of' do
    it 'should return true so as user is author of the entity' do
      expect(user_with_questions).to be_author_of(user_with_questions.questions.first)
    end

    it '#author_of should return false so as user is not author of the entity' do
      expect(user).to_not be_author_of(user_with_questions.questions.first)
    end
  end
end

