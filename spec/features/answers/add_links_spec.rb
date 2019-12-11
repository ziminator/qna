require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add liks
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/ziminator/8d3a2583c4b3dad144acbd9d293ad96f' }

  scenario 'User adds link when give an answer', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Your answer', with: 'My answer'
    click_on 'Create'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Create'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
