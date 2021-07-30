require 'rails_helper'

feature 'User can delete attached to answer link', %q{
  In order to provide users with relevant link
  As anauthor of uestion
  I'd to be able to delete links attached to my answer
} do

  given!(:user) { create :user }
  given!(:user2) { create :user }
  given!(:question) { create :question, author: user }
  given!(:question2) { create :question, author: user2 }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:answer2) { create(:answer, question: question2, author: user2) }
  given!(:link) { create :link, linkable: answer }
  given!(:link2) { create :link, linkable: answer2 }



  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'as an author of answer deletes attached link' do
      within('.answer-links') do
        click_on "Remove link"
        expect(page).to_not have_content link.name
      end
      expect(page).to have_content 'Link was successfully removed.'
    end

    scenario 'while not being an author of the question cannot delete attached links' do
      visit question_path(question2)

      expect(page).to_not have_link "Remove answer's link"
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'tries to delete attached link' do
      visit question_path(question)

      expect(page).to_not have_link "Remove answer's link"
    end
  end

end
