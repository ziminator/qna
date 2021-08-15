require 'rails_helper'

feature 'User can unsubscribe from question', %q{
  In order to stop being informed about certain question
  As an authenticated user
  I'd like to be able to stop receive notifications for new answers
} do
  given(:user) { create :user }
  given(:question) { create :question, author: user }

  scenario 'authenticated user', js: true do
    sign_in user
    visit question_path(question)

    click_on 'Unsubscribe'

    expect(page).to_not have_content 'Unsubscribe'
    expect(page).to have_content 'Subscribe'
  end

  scenario 'Unauthenticated user', js: true do
    visit question_path(question)

    expect(page).to_not have_content 'Unsubscribe'
  end
end
