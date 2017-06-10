FactoryGirl.define do
  factory :answer do
    body "MyText"

    factory :invalid_answer do
    body nil
    end
  end
end
