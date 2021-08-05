FactoryBot.define do
  factory :comment do
    comment_body { "text text" }

    trait :invalid do
      comment_body { nil }
    end
  end
end
