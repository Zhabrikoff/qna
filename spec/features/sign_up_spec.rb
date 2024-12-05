# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign up', "
  In order to ask questions or to write answer
  As an unauthenticated user
  I'd like to be able to sign up
" do
  background do
    visit new_user_registration_path
  end

  scenario 'User tries to sign up with valid data' do
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '1234567890'
    fill_in 'Password confirmation', with: '1234567890'

    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User tries to sign up with invalid data' do
    fill_in 'Email', with: 'test@test.com'

    click_on 'Sign up'

    expect(page).to have_content "Password can't be blank"
  end
end
