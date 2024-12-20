# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign out', "
  In order to sign out of the application
  As an authenticated user
  I'd like to be able to sign out
" do
  given(:user) { create(:user) }

  background do
    sign_in(user)

    visit root_path
  end

  scenario 'Authenticated user tries to sign out' do
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
