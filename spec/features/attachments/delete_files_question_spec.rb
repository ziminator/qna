require 'rails_helper'

feature 'User can delete files', %q{
  User can delete attached files from the question
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'Authenticated user' do
    before { sign_in(author) }
    before do
      add_file_to(question)
      visit question_path(question)
    end

    scenario 'author of question can delete the attachment' do
      within(".attachment-#{question.files.first.id}") do
        click_on 'Delete file'
      end
    end
  end
end
