FactoryBot.define do
  factory :answer do
    body { "MyTextAnswer" }

    factory :answer_sequence do
      sequence(:body) { |n| "MyTextAnswer#{n}" }
    end

    trait :invalid do
      body { nil }
    end

    trait :edit_body do
      body { 'New body' }
    end
  end
end
