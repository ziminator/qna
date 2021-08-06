require 'rails_helper'

feature 'User can delete a question', %q{
  In order to delete the question
  As an author of question
  I'd like to delete the question
} do

  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, author: user1) }

  describe 'Authenticated user' do
    scenario 'user is the author of the question' do
      sign_in(user1)
      visit question_path(question)
      click_on 'Delete question'

      expect(page).to have_content 'Question was deleted.'
      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
    end

    scenario 'user is not the author of the question' do
      sign_in(user2)
      visit question_path(question)

      expect(page).to_not have_link 'Delete question'
    end
  end

  scenario 'Unauthenticated user tries to delete a question' do
    visit questions_path

    expect(page).to_not have_link 'Delete question'
  end
end
