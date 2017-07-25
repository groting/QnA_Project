require 'rails_helper'

RSpec.describe User do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:comments) }
  it { should have_many(:authorizations) }
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

  describe '.find_for_oauth' do
    let!(:user)  { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new('devise.provider' => 'facebook', 'devise.uid' => '123456') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new('devise.provider' => 'facebook',
            'devise.uid' => '123456', 'devise.email' => user.email) }
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth['devise.provider']
          expect(authorization.uid).to eq auth['devise.uid']
        end

        it 'retruns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exixts' do
        let(:auth) { OmniAuth::AuthHash.new('devise.provider' => 'facebook',
            'devise.uid' => '123456', 'devise.email' => 'new@email') }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end
        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end
        it 'fills user email'do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth['devise.email']
        end
        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end
        it 'creates authoriation with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth['devise.provider']
          expect(authorization.uid).to eq auth['devise.uid']
        end
      end
    end
  end
end

