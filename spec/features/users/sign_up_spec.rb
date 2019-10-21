require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask question,
  As a guest,
  I'd like to sign up.
} do

  given(:user) { create(:user) }

  describe 'Guest click on Sign Up link' do

    background { visit new_user_registration_path }

    scenario 'Unregistered user tries to sign up' do
      fill_in 'Email', with: 'user@domain.com'
      fill_in 'Password', with: 'userpassword'
      fill_in 'Password confirmation', with: 'userpassword'
      click_button 'Sign up'

      expect(page).to have_content 'Welcome! You have signed up successfully.'
      expect(current_path).to eq root_path
    end

    scenario 'Sign up with error(blank fields)' do
      fill_in 'Email', with: ''
      fill_in 'Password', with: ''
      fill_in 'Password confirmation', with: ''
      click_button 'Sign up'

      expect(page).to have_content "Email can't be blank"
      expect(page).to have_content "Password can't be blank"
    end

    scenario 'Sign up with error(different passwords)' do
      fill_in 'Email', with: 'user@domain.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '87654321'
      click_button 'Sign up'

      expect(page).to have_content "Password confirmation doesn't match Password"
    end

    scenario 'Sign up with error(email is already taken)' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password
      click_button 'Sign up'
      expect(page).to have_content 'Email has already been taken'
    end
  end
end
