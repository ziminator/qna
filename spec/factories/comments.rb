FactoryBot.define do
  factory :comment do
    comment_body { "text text" }
    association :author, factory: :user

    trait :invalid do
      comment_body { nil }
    end
  end

  factory :question_comment, class: Comment do
    association :commentable, factory: :question
    body { "Comment text" }
    association :author, factory: :user
  end

  factory :answer_comment, class: Comment do
    association :commentable, factory: :answer
    body { "Comment text" }
    association :author, factory: :user
  end
end
