FactoryBot.define do
  sequence :body do |n|
    "AnswerText#{n}"
  end
  factory :answer do
    body
    association :question

    trait :invalid do
      body { nil }
    end

    trait :edit_body do
      body { 'New body' }
    end
  end
end
