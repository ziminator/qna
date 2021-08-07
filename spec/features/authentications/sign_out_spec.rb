require 'rails_helper'

feature 'Autnenticated user  can sign out', %q{
  In order to stop session
  As authenticated user
  I'd like to sign out
} do
  given(:user) { create(:user) }

  background do
    sign_in(user)
    click_on 'Logout'
  end

  scenario 'Authenticated user tries to sign out' do
    expect(page).to have_content 'Signed out successfully.'
  end
end
