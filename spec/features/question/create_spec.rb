# frozen_string_literal: true

require 'rails_helper'

feature 'User can create question', "
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
" do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Test text'

      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'Test text'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content 'Title can\'t be blank'
    end

    scenario 'asks a question with attached file' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Test text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  context 'multiple sessions', js: true do
    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)

        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'

        expect(page).to have_current_path(new_question_path)

        # Проверяем наличие полей формы
        expect(page).to have_field('question[title]')
        expect(page).to have_field('question[body]')

        fill_in 'question[title]', with: 'Test question'
        fill_in 'question[body]', with: 'Test text'

        click_on 'Ask'

        expect(page).to have_content 'Test question'
        expect(page).to have_content 'Test text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content('Test question', wait: 10)
      end
    end
  end

  scenario 'Unauthenticated user tries to asks a question' do
    visit questions_path

    expect(page).not_to have_button 'Ask question'
  end
end
