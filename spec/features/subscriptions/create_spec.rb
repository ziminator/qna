require 'rails_helper'

feature 'User can subscribe to question', %q{
  In order to stay informed
  As an authenticated user
  I'd like to be able to receive notifications about new answers for subscribed question
} do
  given(:user) { create :user }
  given(:question) { create :question, author: user }
  given(:user2) { create :user }

  scenario 'authenticated user', js: true do
    sign_in user2
    visit question_path(question)

    click_on 'Subscribe'

    expect(page).to_not have_content 'Subscribe'
    expect(page).to have_content 'Unsubscribe'
  end

  scenario 'Unauthenticated user', js: true do
    visit question_path(question)

    expect(page).to_not have_content 'Subscribe'
  end
end
