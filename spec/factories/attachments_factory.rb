FactoryBot.define do
  #factory :body do
  #  "answer body"
  #end

  factory :attach_file do
    attach_file  { File.new("#{Rails.root.join('spec/rails_helper.rb')}") }
  end
end
