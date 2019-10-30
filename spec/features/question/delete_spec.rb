require 'rails_helper'

feature 'User can delete question' do
  given(:author) { create(:user) }
  given(:any_auth_user) { create(:user) }
  given(:question) { create(:question, user: author) }

  scenario 'Author remove question' do
    sign_in(author)

    visit question_path(question)
    expect(page).to have_content 'Remove question'

    click_on 'Remove question'

    expect(page).to have_content 'Your question deleted sucessfully.'
    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
  end

  scenario 'Not author remove question' do
    sign_in(any_auth_user)
    visit question_path(question)
    expect(page).to_not have_content 'Remove question'
  end

  scenario 'Not authenticated user asks a question' do
    visit question_path(question)
    expect(page).to_not have_content 'Remove question'
  end
end
