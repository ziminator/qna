FactoryBot.define do
  factory :attach do
    attach_file  { File.new("#{Rails.root.join('spec/rails_helper.rb')}") }
  end
end
