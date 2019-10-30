require 'rails_helper'

feature 'User can delete answer' do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: author) }

    scenario 'Author can delete answer' do
      sign_in(author)
      visit question_path(question)

      expect(page).to have_content answer.body

      click_on 'Remove answer'

      expect(page).to have_content 'Your answer deleted sucessfully!'
    end

    scenario 'Non author delete answer' do
      sign_in(user)

      visit question_path(question)

      expect(page).to_not have_content 'Remove answer'
    end

    scenario 'Not authenticated user delete answer' do
      visit question_path(question)
      expect(page).to_not have_content 'Remove answer'
    end
end
