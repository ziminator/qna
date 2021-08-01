require 'rails_helper'

feature 'User can view list of all questions', %q{
  In order to find a solution for interested question
  As any kind of user
  I'd like to have an ability look thru all questions
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, author: user) }

  scenario 'User can look thru all questions' do
    visit questions_path
    questions.each { |q| expect(page).to have_content(q.title) }
  end

  scenario 'Auth user can look thru all questions' do
    sign_in(user)
    visit questions_path
    questions.each { |q| expect(page).to have_content(q.title) }
  end
end
