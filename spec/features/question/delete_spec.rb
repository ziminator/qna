require 'rails_helper'

feature 'User can delete question' do
  given(:author) { create(:user) }
  given(:any_auth_user) { create(:user) }
  given(:question) { create(:question, user: author) }

  background do
    visit question_path(question)
  end

  scenario 'Author remove question' do
    sign_in(author)

    click_on 'Delete question'

    expect(page).to have_content 'Question successfully deleted.'
    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
  end

  scenario 'Not author remove question' do
    sign_in(any_auth_user)
    expect(page).to_not have_content 'Delete question'
  end

  scenario 'Not authenticated user asks a question' do
    expect(page).to_not have_content 'Delete question'
  end
end
