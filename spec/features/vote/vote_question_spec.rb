require 'rails_helper'

feature 'User can use voting system', %q{
  In order to provide community with addional info
  As an authenticated user
  I'd like to use vote system to vote question
}do
  given(:user) { create :user }
  given(:other_user) { create :user }
  given!(:question) { create :question, author: other_user }
  given!(:question1) { create :question, author: user }

  describe 'User votes for question', js: true do
    context 'Authenticated user' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'votes up' do
        visit question_path(question)
        within(".question-#{question.id}") do
          find('a.fa-caret-up').click
          expect(find('.score')).to have_content '1'
        end
      end

      scenario 'votes down' do
        within(".question-#{question.id}") do
          find('.fa-caret-down').click

          expect(find('.score')).to have_content '-1'
        end
      end

      scenario 'votes up only ones' do
        within(".question-#{question.id}") do
          find('.fa-caret-up').click
          find('.fa-caret-up').click

          expect(find('.score')).to have_content '1'
        end
      end

      scenario 'votes down only ones' do
        within(".question-#{question.id}") do
          find('.fa-caret-down').click
          find('.fa-caret-down').click

          expect(find('.score')).to have_content '-1'
        end
      end

      scenario 'votes for own question' do
        visit question_path(question1)
        within ".question-#{question1.id}" do
          find('.fa-caret-down').click

          expect(find('.score')).to have_content '0'
        end
      end
    end

    context 'Unauthenticated user' do
      background do
        visit question_path(question)
      end

      scenario 'votes up fo question' do
        expect(page).to_not have_selector('.voting')
      end
    end
  end
end
