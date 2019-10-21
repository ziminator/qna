require 'rails_helper'

feature 'User can delete answer' do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: author) }

    background do
      visit question_path(question)
    end

    scenario 'Author can delete answer' do
      sign_in(author)

      click_on 'Remove answer'

      expect(page).to have_content 'Your answer deleted sucessfully!'
      expect(page).to_not have_content answer.body
    end

    scenario 'Non author delete answer' do
      sign_in(user)

      expect(page).to_not have_content 'Remove answer'
    end

    scenario 'Not authenticated user delete answer' do
      expect(page).to_not have_content 'Delete answer'
    end
end
