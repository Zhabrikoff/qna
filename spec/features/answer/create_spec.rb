# frozen_string_literal: true

require 'rails_helper'

feature 'User can create answer', "
  In order to answer the question
  As an authenticated user
  I'd like to be able to create an answer for a specific question
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'creates an answer' do
      fill_in 'Body', with: 'Test answer'

      click_on 'Answer'

      expect(current_path).to eq question_path(question)

      within '.answers' do
        expect(page).to have_content 'Test answer'
      end
    end

    scenario 'creates an answer with errors' do
      fill_in 'Body', with: ''

      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to write answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Answer'
  end
end
