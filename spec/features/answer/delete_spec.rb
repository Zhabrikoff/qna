# frozen_string_literal: true

require 'rails_helper'

feature 'User can create answer', "
  In order to remove answer
  As an author of answer
  I'd like to be able to delete my answer
" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'Author deletes his answer' do
    sign_in(author)

    visit question_path(question)

    click_on 'Delete answer'

    expect(page).to_not have_content answer.body
  end

  scenario 'Non-author tries to delete answer' do
    sign_in(user)

    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
end
