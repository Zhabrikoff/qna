# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:link) { 'https://www.google.com/' }

  scenario 'User adds link whe asks answer', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Body', with: 'Test answer'
    fill_in 'Link name', with: 'My link'
    fill_in 'Url', with: link

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My link', href: link
    end
  end
end
