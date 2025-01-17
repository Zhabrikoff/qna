# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete links in his answer', "
  In order to remove links in answer
  As an author of answer
  I'd like to be able to delete links in my answer
" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, :with_link, question: question, user: author) }

  scenario 'Author deletes link from answer', js: true do
    sign_in(author)

    visit question_path(question)

    within '.answer-links' do
      accept_alert do
        click_on 'delete'
      end
    end

    expect(page).to_not have_link answer.links.first.name
  end

  scenario 'Non-author tries to delete link in answer' do
    sign_in(user)

    visit question_path(question)

    within '.answer-links' do
      expect(page).to_not have_link 'delete'
    end
  end
end
