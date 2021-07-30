require 'rails_helper'

feature 'User can look thru his awards' do
  given(:user) { create :user }
  given!(:question) { create :question, author: user }
  given!(:award) { create :award, :with_image, question: question }
  given!(:answer) { create :answer, question: question, author: user }

  it 'renders awards page', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Set the Best'
    visit awards_path

    expect(page).to have_content question.title
    expect(page).to have_content award.name
    expect(page).to have_selector 'img'
  end
end
