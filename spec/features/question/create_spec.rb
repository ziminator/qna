require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated User
  I'd like to be able to ask question
} do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user asks a question with errors' do
    visit questions_path
    expect(page).to_not have_button 'Log in'
    #click_on 'Ask question'
    #save_and_open_page
    #expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end


