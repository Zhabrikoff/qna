# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete links in his question', "
  In order to remove links in question
  As an author of question
  I'd like to be able to delete links in my question
" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, :with_link, user: author) }

  scenario 'Author deletes his question', js: true do
    sign_in(author)

    visit question_path(question)

    within '.question-links' do
      accept_alert do
        click_on 'delete'
      end
    end

    expect(page).to_not have_link question.links.first.name
  end

  scenario 'Non-author tries to delete links' do
    sign_in(user)

    visit question_path(question)

    within '.question-links' do
      expect(page).to_not have_link 'delete'
    end
  end
end
