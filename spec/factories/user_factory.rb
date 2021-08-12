FactoryBot.define do
  sequence :email do |n|
    "user#{n}@mail.net"
  end

  factory :user do
    email
    password { '111111' }
    password_confirmation { '111111' }

    before(:create) {|user| user.skip_confirmation! }
  end
end
