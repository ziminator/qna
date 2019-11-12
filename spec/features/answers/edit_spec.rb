require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given(:user) { create(:user) }
  given(:guest) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    before { sign_in(user) }

    scenario "Edit user's answer", js: true do
      answer = create(:answer, user: user, question: question)
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'

        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
      expect(page).to have_content 'Your answer successfully updated.'
    end

    scenario "Guest cannot edit user's answer", js: true do
      create(:answer, guest: user, question: question)

      visit question_path(question)

      expect(page).to have_no_link 'Edit'
    end
  end
end

