require 'rails_helper'

feature 'User can delete files attached to his question', %q{
  In order to delete files for your question
  As an author of the question
  I'd like to be able to delete files for my question
} do

  given!(:user) { create :user }
  given!(:question) { create :question, author: user }

  scenario 'Unauthenticated can not delete files' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete file'
  end

  describe 'Authenticated user as an author', js: true do
    background do
      sign_in user
      visit question_path(question)

      click_on 'Edit question'

      within '.question' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save question'
      end
    end

    scenario "deletes his question's file" do
      within '.question' do
        click_on 'Edit question'

        within ".file-#{question.files.first.id}" do
          click_on 'Delete file'
        end

        expect(page).to_not have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  describe 'Authenticated user as not an author', js: true do
    given!(:user2) { create :user }

    scenario 'tries to delete attached file othat belongs to other user' do
      sign_in user2
      visit question_path(question)

      expect(page).to_not have_link 'Delete file'
    end
  end
end
