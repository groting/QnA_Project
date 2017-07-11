FactoryGirl.define do
  factory :vote do
    user
    factory :like_vote do
      value 1
    end
    factory :dislike_vote do
      value -1
    end
  end
end