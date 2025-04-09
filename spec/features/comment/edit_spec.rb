# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit comment', "
  In order to edit comment
  As an author of comment
  I'd like to be able to edit my comment
" do
  given!(:question) { create(:question) }

  describe 'Unauthenticated user' do
    given!(:comment) { create(:comment, commentable: question) }

    scenario 'edit comment' do
      visit question_path(question)

      within "#comment-id-#{comment.id}" do
        expect(page).to have_no_link 'edit'
      end
    end
  end

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }
    given!(:comment) { create(:comment, commentable: question, user: user) }

    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'edits comment' do
      within "#comment-id-#{comment.id}" do
        click_on 'edit'

        fill_in 'Your comment', with: 'edited comment'
        click_on 'Save'

        expect(page).to have_no_content comment.body
        expect(page).to have_content 'edited comment'
        expect(page).to have_no_element 'input'
      end
    end

    scenario 'edits comment with errors' do
      within "#comment-id-#{comment.id}" do
        click_on 'edit'

        fill_in 'Your comment', with: ''
        click_on 'Save'

        expect(page).to have_content comment.body
        expect(page).to have_element 'input'
      end
    end
  end
end
