FactoryGirl.define do
  sequence :body do |n|
    "AnswerText#{n}"
  end

  factory :answer do
    body
    question
    user
    factory :invalid_answer do
      body nil
    end
  end
end
