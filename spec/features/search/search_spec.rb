# frozen_string_literal: true

require 'sphinx_helper'

feature 'User can search answer, questions, comments, users', "
  In order to find information in the community
  As an authenticated user
  I'd like to be able to search for information
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, body: 'answer', user: user) }
  given!(:comment) { create(:comment, commentable: question, user: user) }

  background do
    visit root_path

    ThinkingSphinx::Test.index
  end

  describe 'User searches one type:', sphinx: true, js: true do
    scenario 'Answer' do
      ThinkingSphinx::Test.run do
        fill_in 'query', with: 'answer'
        find('input[type="radio"][value="Answer"]').click
        click_on 'Search'

        expect(page).to have_selector('.search-results')

        within '.search-results' do
          expect(page).to have_content 'answer'
        end
      end
    end

    scenario 'Question' do
      ThinkingSphinx::Test.run do
        fill_in 'query', with: question.title
        find('input[type="radio"][value="Question"]').click
        click_on 'Search'

        expect(page).to have_selector('.search-results')

        within '.search-results' do
          expect(page).to have_content question.title
        end
      end
    end

    scenario 'Comment' do
      ThinkingSphinx::Test.run do
        fill_in 'query', with: comment.body
        find('input[type="radio"][value="Comment"]').click
        click_on 'Search'

        expect(page).to have_selector('.search-results')

        within '.search-results' do
          expect(page).to have_content comment.body
        end
      end
    end

    scenario 'User' do
      ThinkingSphinx::Test.run do
        fill_in 'query', with: 'test'
        find('input[type="radio"][value="User"]').click
        click_on 'Search'

        expect(page).to have_selector('.search-results')

        within '.search-results' do
          expect(page).to have_content(/@test\.com/)
        end
      end
    end
  end
end
