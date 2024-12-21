# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete files in his question', "
  In order to remove files in question
  As an author of question
  I'd like to be able to delete files in my question
" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, :with_file, user: author) }

  scenario 'Author deletes files in his question' do
    sign_in(author)

    visit question_path(question)

    within '.question-files' do
      accept_alert do
        click_on 'Delete'
      end
    end

    expect(page).to_not have_link question.files.first.blob.filename
  end

  scenario 'Non-author tries to delete files' do
    sign_in(user)

    visit question_path(question)

    within '.question-files' do
      expect(page).to_not have_link 'Delete'
    end
  end
end
