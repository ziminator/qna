FactoryBot.define do
  factory :answer do
    body { "MyTextAnswer" }
    association :author, factory: :user

    factory :answer_sequence do
      sequence(:body) { |n| "MyTextAnswer#{n}" }
    end

    trait :invalid do
      body { nil }
    end

    trait :edit_body do
      body { 'New body' }
    end

    trait :with_files do
      files { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb") }
    end

    trait :with_links do
      after(:create) { |answer| create(:link, linkable: answer) }
    end

    trait :with_comments do
      after(:create) { |answer| create(:answer_comment, commentable: answer, author: answer.author) }
    end
  end
end
