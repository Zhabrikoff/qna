# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete comment', "
  In order to remove comment
  As an author of comment
  I'd like to be able to delete my comment
", :js do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:comment) { create(:comment, commentable: question, user: author) }

  scenario 'Author deletes his comment' do
    sign_in(author)

    visit question_path(question)

    within "#comment-id-#{comment.id}" do
      accept_alert do
        click_on 'delete'
      end
    end

    expect(page).to have_no_content comment.body
  end

  scenario 'Non-author tries to delete answer' do
    sign_in(user)

    visit question_path(question)

    within "#comment-id-#{comment.id}" do
      expect(page).to have_no_link 'delete'
    end
  end
end
