# frozen_string_literal: true

require 'rails_helper'

feature 'User can create question', "
  In order to remove question
  As an author of question
  I'd like to be able to delete my question
" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }

  scenario 'Author deletes his question' do
    sign_in(author)

    visit question_path(question)

    click_on 'Delete question'

    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
  end

  scenario 'Non-author tries to delete question' do
    sign_in(user)

    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end
end
