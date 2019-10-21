require 'rails_helper'

feature 'User can view the list of questions' do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user) }

  scenario 'questions list' do
    visit questions_path

    questions.each { |question| expect(page).to have_content question.title }
  end
end
