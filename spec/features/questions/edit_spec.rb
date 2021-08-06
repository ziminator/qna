require 'rails_helper'

feature 'User can edit his question', %q{
  In order to edit question or fix mistakes
  As an author of question
  I'd like to be able to edit my question
} do

  given!(:user) { create :user }
  given!(:question) { create :question, author: user }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user as author', js: true do
    given!(:url) { 'http://google.com' }

    background do
      sign_in user
      visit question_path(question)

      click_on 'Edit question'
    end

    scenario 'edit his question' do
      within '.question' do
        fill_in 'Title', with: 'new title'
        fill_in 'Body', with: 'new body'
        click_on 'Save question'
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'new title'
        expect(page).to_not have_selector 'text_field'
      end
    end

    scenario 'edits his question with errors' do
      within '.question' do
        fill_in 'Title', with: ''
        click_on 'Add link'
        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: 'invalid.cpm'
        click_on 'Save question'

        expect(page).to have_content question.title
      end

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Links url is not a valid URL"
    end

    scenario 'edits his question with attachments' do
      within '.question' do
        fill_in 'Title', with: 'new title'
        fill_in 'Body', with: 'new body'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save question'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'new title'
        expect(page).to_not have_selector 'text_field'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits link attached to question' do
      within '.question' do
        click_on 'Add link'
        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: url
        click_on 'Save question'
        expect(page).to have_link 'Google'
      end
    end

  end

  describe 'Authenticated user as not author', js: true do
    given!(:user2) { create :user }

    scenario "tries to edit other user's question" do
      sign_in user2
      visit question_path(question)

      expect(page).to_not have_link 'Edit question'
    end
  end
end
