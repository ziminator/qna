require 'rails_helper'

feature 'User can sign in via social networks', %q{
  In order to faster get access to resource
  As an unauthenticated user
  I'd like to be able to sing in via social networks
} do

  context ' Sign up' do
    before { visit new_user_registration_path }

    scenario 'via Github', js: true do
      mock_auth_hash
      click_on "Sign in with GitHub"

      expect(page).to have_content'Welcome! mail@mail.net'
      expect(page).to have_content'Logout'
    end

    scenario 'via vkontakte', js: true do
      click_on "Sign in with Vkontakte"

      expect(page).to have_content'Welcome! mail@mail.net'
      expect(page).to have_content'Logout'
    end

    scenario 'via Instagram', js: true do
      clear_emails

      click_on "Sign in with Instagram"

      fill_in 'Email', with: 'mail2@mail.net'
      click_on 'Update User'
      sleep 2
      open_email('mail2@mail.net')
      current_email.click_link 'Confirm my account'

      expect(page).to have_content'Welcome! mail2@mail.net'
      expect(page).to have_content'Logout'
    end
  end

  context 'Sign in' do
    let!(:user) { create(:user, email: 'mail@mail.net') }

    before { visit new_user_session_path }

    scenario 'via GitHub', js: true do
      click_on "Sign in with GitHub"

      expect(page).to have_content'Welcome! mail@mail.net'
      expect(page).to have_content'Logout'
    end

    scenario 'via vkontakte', js: true do
      click_on "Sign in with Vkontakte"

      expect(page).to have_content'Welcome! mail@mail.net'
      expect(page).to have_content'Successfully authenticated from Vkontakte'
    end

    scenario 'via Instagram', js: true do
      clear_emails

      click_on "Sign in with Instagram"

      fill_in 'Email', with: 'mail@mail.net'
      click_on 'Update User'

      expect(page).to have_content 'Email has already been taken'
    end
  end
end
