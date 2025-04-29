# frozen_string_literal: true

require 'rails_helper'

feature 'User can subscribe to a question', "
  In order to get notifications about new answers
  As an authenticated user
  I'd like to be able to subscribe to a question
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:other_question) { create(:question) }

  scenario 'Authenticated user can subscribe to a question', js: true do
    sign_in user

    visit question_path(other_question)

    click_on 'Subscribe'

    expect(page).to have_no_content 'Subscribe'
    expect(page).to have_content 'Unsubscribe'
  end

  scenario 'Authenticated user can unsubscribe from a question', js: true do
    sign_in user
    create(:subscription, user: user, question: other_question)

    visit question_path(other_question)

    click_on 'Unsubscribe'

    expect(page).to have_content 'Subscribe'
    expect(page).to have_no_content 'Unsubscribe'
  end

  scenario 'Unauthenticated user can not subscribe to a question' do
    visit question_path(question)

    expect(page).to have_no_content 'Subscribe'
    expect(page).to have_no_content 'Unsubscribe'
  end
end
