require 'rails_helper'

feature 'User can create an answer', %q{
  In order to help other users
  As an authenticated User
  I'd like to be able to ask the question
  } do

    given(:user) { create(:user) }
    given(:question) { create(:question, author: user) }

    describe 'Authenticated user', js: true do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'create an answer' do
        fill_in 'Answer body', with: 'text body'
        click_on 'Create answer'

        expect(page).to have_content 'Your answer was successfully created.'
        expect(page).to have_content 'text body'
      end

      scenario 'creates an answer and attach files' do
        fill_in 'Answer body', with: 'text text text'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Create answer'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'create invalid answer' do
        click_on 'Create answer'

        expect(page).to have_content "Body can't be blank"
      end
    end

    describe 'multiple sessions', js: true do
      scenario 'answer appears on another users page' do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)
        end

        Capybara.using_session('guest') do
          visit question_path(question)
        end

        Capybara.using_session('user') do
          fill_in 'Answer body', with: 'text text text'

          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Create answer'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'text text text'
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end

    scenario 'Unauthenticated user tries to create an answer' do
      visit question_path(question)

      expect(page).to_not have_content 'Create answer'
    end
  end
