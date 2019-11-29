require 'rails_helper'

feature 'User can delete files', %q{
  User can delete attached files from the answer
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given(:answer) { create(:answer, question: question, user: author) }
  given(:attach) { create(:attach) }

  describe 'Authenticated user' do
    before do
      sign_in(author)
      add_file_to(answer)
      visit question_path(question)

      #save_and_open_page
      #fill_in 'Body', with: 'answer body'
      #attach_file 'File', ["#{Rails.root.join('spec/rails_helper.rb')}", "#{Rails.root.join('spec/rails_helper.rb').to_s}"]

      #attributes_for(:attach_file)

      #click_on 'Answer'
    end

    scenario 'author of answer can delete the attachment' do
      fill_in 'Body', with: 'answer body'
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
