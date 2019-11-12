require 'rails_helper'

feature 'User can sign out', %q{
  In order to end session,
  As an athenticated user,
  I'd like to sign out.
} do

  given(:user) { create(:user) }

  describe 'Click on Sign out link' do
    background { sign_in(user) }
    scenario 'Registered user tries to sign out' do
      click_on 'Sign out'

      expect(page).to have_content 'Signed out successfully.'
      expect(current_path).to eq root_path
    end
  end

  scenario 'Unregistered user tries to sign out' do
    expect(page).to_not have_link 'Sign out'
  end
end
