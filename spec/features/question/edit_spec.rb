# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'edits his question' do
      click_on 'Edit'

      within '.question' do
        within '.edit-question' do
          fill_in 'Title', with: 'Question Title'
          fill_in 'Body', with: 'Question body'
        end

        click_on 'Save'

        expect(page).to_not have_content 'MyQuestionString'
        expect(page).to have_content 'Question Title'
        expect(page).to_not have_selector('form#edit-question')
      end
    end

    scenario 'edits his question with errors' do
      click_on 'Edit'

      within '.question' do
        within '.edit-question' do
          fill_in 'Title', with: ''
          fill_in 'Body', with: ''
        end

        click_on 'Save'

        expect(page).to have_content question.body
        expect(page).to have_selector 'textarea'
      end
    end

    context 'tries to edit' do
      given(:another_user) { create(:user) }
      given!(:question) { create(:question, user: another_user) }

      scenario 'other user\'s questions' do
        within '.question' do
          expect(page).to_not have_link 'edit'
        end
      end
    end
  end
end
