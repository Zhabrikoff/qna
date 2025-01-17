# frozen_string_literal: true

require 'rails_helper'

feature 'User can view his profile', "
  In order to view my profile
  As an authenticated user
  I'd like to be able to view my profile
" do
  given(:question) { create(:question, :with_award) }
  given(:award) { question.award }
  given(:user) { create(:user, awards: [award]) }

  background do
    sign_in(user)

    visit root_path

    click_on 'Profile'
  end

  scenario 'User visits his profile' do
    expect(page).to have_content user.email
  end

  scenario 'User views his awards' do
    expect(page).to have_content award.name
  end
end
