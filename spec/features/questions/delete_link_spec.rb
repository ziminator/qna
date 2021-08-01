require 'rails_helper'

feature 'User can delete attached to question link', %q{
  In order to provide users with relevant link
  As anauthor of uestion
  I'd to be able to delete links in my question
} do

  given(:user) { create(:user) }
  given(:user2) { create :user }
  given(:question_1) { create(:question, author: user) }
  given(:question_2) { create(:question, author: user2) }
  given!(:link_1) { create :link, linkable: question_1, name: 'google', url: 'http://google.com' }
  given!(:link_2) { create :link, linkable: question_2, name: 'google', url: 'http://google.com' }


  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question_1)
    end

    scenario 'as an author of question deletes attached link' do
      within('.question') do
        click_on 'Remove link'
      end

      expect(page).to_not have_content link_1.name
      expect(page).to_not have_content link_1.url
      expect(page).to have_content 'Link was successfully removed.'
    end

    scenario 'while not being an author of the question cannot delete attached links' do
      visit question_path(question_2)

      expect(page).to_not have_link 'Remove link'
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'tries to delete attached link' do
      visit question_path(question_1)

      expect(page).to_not have_link 'Remove link'
    end
  end

end
