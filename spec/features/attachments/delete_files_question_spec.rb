require 'rails_helper'

feature 'User can delete files', %q{
  User can delete attached files from the question
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'Authenticated user' do
    before do
      sign_in(author)
      add_file_to(question)
      visit question_path(question)
    end

    scenario 'author of question can delete the attachment' do
      within ".attachment-#{question.files.first.id}" do
        expect(page).to have_link 'rails_helper.rb'
        click_on 'Remove attachment'
      end

      within ".question" do
        expect(page).to_not have_link 'rails_helper.rb'
      end
    end

    scenario 'non author of question try to delete the attachment' do
      sign_in(user)
      within ".attachment-#{question.files.first.id}" do
        expect(page).to_not have_link 'Remove attachment'
      end
    end

    scenario 'guest try to delete the attachment' do
      within ".attachment-#{question.files.first.id}" do
        expect(page).to_not have_link 'Remove attachment'
      end
    end
  end
end
