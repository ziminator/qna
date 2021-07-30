require 'rails_helper'

feature 'Best answer', %q{
  to choose the answer which is the best
  As an authenticated user
  I want to be able to set best answer to my question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answers) { create_list(:answer, 3, question: question, author: user) }


  describe 'Unauthenticated user' do
    background { visit question_path(question) }

    scenario 'cannot choose the best answer' do
      expect(page).not_to have_link 'Set the Best'
    end
  end

  describe 'Authenticated user', js: true do
    context 'As an author of the question' do
      background do
        sign_in user
        visit question_path(question)
      end

      scenario 'selects only one best answer and sees it at the top' do
        best_answer = answers[2]
        within(".answer-#{best_answer.id}") { click_on 'Set the Best' }
        first_answer = find('.answers').first(:element)
        within first_answer do
          expect(page).to have_content best_answer.body
        end
      end

      scenario 'selects another best answer and sees it at the top' do
        best_answer = answers[2]
        new_best_answer = answers[1]

        within(".answer-#{best_answer.id}") { click_on 'Set the Best' }
        within(".answer-#{new_best_answer.id}") { click_on 'Set the Best' }

        first_answer = find('.answers').first(:element)

        within first_answer do
          expect(page).to have_content new_best_answer.body
        end
      end
    end

    context 'As NOT an author of the question' do
      given(:user2) { create(:user) }

      background do
        sign_in user2
        visit question_path(question)
      end

      scenario 'cannot choose the best answer' do
        expect(page).not_to have_link 'Set the Best'
      end
    end
  end
end
