require 'rails_helper'

feature 'User can look certain question', %q{
  In order to look an exact question and create an answer
  As user
  I'd like to be able to select question from list of all questions
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'User can look certain question' do
    visit question_path(question)

    expect(page).to have_content(question.title)
  end
end
