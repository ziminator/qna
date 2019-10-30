require 'rails_helper'

feature 'User can create answer', %q{
  As an authenticated user
  being on the question page
  can write the answer to the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answer the question' do
      fill_in 'Body', with: 'answer body'

      click_on 'Answer'
      expect(page).to have_content 'answer body'
    end

    scenario 'answer the question with error' do
      fill_in 'Body', with: ''

      click_on 'Answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Not authenticated user answer a question' do
    visit question_path(question)

    expect(page).to_not have_content 'Answer'
  end
end
