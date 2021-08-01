FactoryBot.define do
  factory :award do
    name { "Award" }

    trait :with_image do
      image { Rack::Test::UploadedFile.new("#{Rails.root}/storage/pic.jpg") }
    end
  end
end
