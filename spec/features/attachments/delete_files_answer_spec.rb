require 'rails_helper'

feature 'User can delete files', %q{
  User can delete attached files from the question
} do

  given(:user) { create(user) }
  given(:author) { create(author) }
  given(:question) { create(:question, ) }


end
