require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be adble to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:answer2) { create(:answer, question: question, author: user2) }

  scenario 'Unaunthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Aunthenticated user' do
    given!(:url) { 'http://google.com' }

    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'as an author edits his answer', js: true do
      within ".answer-#{answer.id}" do
        click_on 'Edit'
        fill_in 'Your answer', with: :edit_body
        click_on 'Save'
        expect(page).to_not have_content answer.body
        expect(page).to have_content :edit_body
        expect(page).to_not have_content 'Your answer'
      end
    end

    scenario 'as an author edits his answer with errors', js: true do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'as an author edits his answer wtih attachments', js: true do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: :edit_body
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits link attached to answer', js: true do
      within '.answers' do
        click_on 'Edit'
        click_on 'Add link'
        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: url
        click_on 'Save'
        expect(page).to have_link 'Google'
      end
    end

    scenario "tries to edit other user's question", js: true do
      within(".answer-#{answer2.id}") do
        expect(page).to have_content(answer2.body)
        expect(page).not_to have_link 'Edit'
      end
    end
  end
end
