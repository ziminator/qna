require 'rails_helper'

feature 'User can delete files', %q{
  User can delete attached files from the answer
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given(:answer) { create(:answer, question: question, user: author) }

  describe 'Authenticated user' do
    background do
      sign_in(author)
      add_file_to(answer)
      visit question_path(question)
    end

    scenario 'author of answer can delete the attachment' do
      fill_in 'Answer body', with: 'Just answer'
      attach_file 'Answer files', answer.files.first.id
      click_on 'Answer'

      within ".attachment-#{answer.files.first.id}" do
        expect(page).to have_link 'rails_helper.rb'
        click_on 'Remove attachment'
      end

      within ".answer-#{answer.id}" do
        expect(page).to_not have_link 'rails_helper.rb'
      end
    end

    scenario 'non author of answer try to delete the attachment' do
      sign_in(user)
      fill_in 'Answer body', with: 'Just answer'
      attach_file 'Answer files', answer.files.first.id
      within ".attachment-#{answer.files.first.id}" do
        expect(page).to_not have_link 'Remove attachment'
      end
    end

    scenario 'guest try to delete the attachment' do
      within ".attachment-#{answer.files.first.id}" do
        expect(page).to_not have_link 'Remove attachment'
      end
    end
  end
end
