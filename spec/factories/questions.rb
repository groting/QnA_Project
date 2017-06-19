FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "QuestionTitle#{n}" }
    sequence(:body) { |n| "QuestionBody#{n}" }
    user

    factory :invalid_question do
      title nil
      body nil
    end

    factory :question_with_answers do
      transient do
        answers_count 5
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question)
      end
    end 
  end
end
