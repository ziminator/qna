FactoryBot.define do
  factory :link do
    name { "MyString" }
    url { "https://gist.github.com/ziminator/8d3a2583c4b3dad144acbd9d293ad96f" }

    trait :invalid_link do
      name { "MyString" }
      url { nil }
    end
  end
end
