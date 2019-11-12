require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated User
  I'd like to be able to sign in
} do

  given(:user) { create(:user) }
  background { visit new_user_session_path }

  describe 'Click on sign in link' do
    scenario 'Registered user tries to sign in' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'

      expect(page).to have_content 'Signed in successfully.'
    end

    scenario 'Registered user tries to sign in with wrong password' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: ''
      click_on 'Log in'

      expect(page).to have_content 'Invalid Email or password.'
      expect(current_path).to eq new_user_session_path
    end
  end

  scenario 'Unregistered user tries to sign in' do

    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
    expect(current_path).to eq new_user_session_path
  end
end
