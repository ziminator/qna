require 'rails_helper'
feature 'User can sign in', %q{
  in order to ask question
  as an unauthenticated User
  i'd like to be able to sign in
} do
  given(:user) { create(:user) }

  background do
    visit root_path
    click_on 'Register'
  end

  scenario 'Unregistred user tries to register' do
    clear_emails

    fill_in 'Email', with: 'user@mail.net'
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    sleep 1
    open_email('user@mail.net')
    current_email.click_link 'Confirm my account'


    fill_in 'Email', with: 'user@mail.net'
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'user@mail.net'
    expect(page).to have_content 'Logout'
  end

  scenario 'User tries to register with error' do
    click_on 'Sign up'
    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end

  scenario 'User tries to register and does not confirm a password' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Sign up'
    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario 'Registred user tries to register with the same email' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'
    expect(page).to have_content 'Email has already been taken'
  end
end
