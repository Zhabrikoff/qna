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
      within '.new-answer' do
        fill_in 'Body', with: 'Test answer'
      end

      click_on 'Answer'

      expect(current_path).to eq question_path(question)

      within '.answers' do
        expect(page).to have_content 'Test answer'
      end
    end

    scenario 'creates an answer with errors' do
      within '.new-answer' do
        fill_in 'Body', with: ''
      end

      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'creates an answer with attached file' do
      within '.new-answer' do
        fill_in 'Body', with: 'Test answer'
      end

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  context 'multiple sessions' do
    scenario "answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)

        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.new-answer' do
          fill_in 'Body', with: 'Test answer'
        end
        click_on 'Answer'

        expect(page).to have_content 'Test answer'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test answer'
      end
    end
  end

  scenario 'Unauthenticated user tries to write answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Answer'
  end
end
