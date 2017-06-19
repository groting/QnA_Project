FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "AnswerText#{n}"}
    question
    user
    factory :invalid_answer do
      body nil
    end  
  end
end
