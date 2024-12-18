# frozen_string_literal: true

require 'rails_helper'

feature 'User can select the best answer', "
  In order to highlight the best answer
  As an author of question
  I'd like to be able to select the best answer
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:another_answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user tries to mark the best answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Mark as best'
    end
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    context 'as the author of the question' do
      scenario 'selects an answer as the best' do
        within "#answer-id-#{answer.id}" do
          click_on 'Mark as best'

          expect(page).to have_content 'Best'
        end
      end

      scenario 'changes the best answer' do
        within "#answer-id-#{answer.id}" do
          click_on 'Mark as best'

          expect(page).to have_content 'Best'
        end

        within "#answer-id-#{another_answer.id}" do
          click_on 'Mark as best'

          expect(page).to have_content 'Best'
        end

        within "#answer-id-#{answer.id}" do
          expect(page).to_not have_content 'Best'
        end
      end
    end

    context 'tries to make the best answer to a question' do
      given(:another_user) { create(:user) }
      given(:another_question) { create(:question, user: another_user) }
      given(:another_answer) { create(:answer, question: another_question, user: another_user) }

      scenario 'that isn\'t his' do
        visit question_path(another_question)

        within '.answers' do
          expect(page).to_not have_link 'Mark as best'
        end
      end
    end
  end
end
