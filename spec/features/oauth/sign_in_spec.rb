# frozen_string_literal: true

require 'rails_helper'

feature 'OAuth Authentication', type: :feature do
  OmniAuth.config.test_mode = true

  context 'Github authentication' do
    scenario 'user can sign in with Github' do
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
                                                                    provider: 'github',
                                                                    uid: '123',
                                                                    info: { email: 'user@example.com' }
                                                                  })
      visit new_user_session_path

      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from Github account.'
    end
  end

  context 'Google authentication' do
    scenario 'user can sign in with Google' do
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
                                                                           provider: 'google_oauth2',
                                                                           uid: '456',
                                                                           info: { email: 'user@example.com' }
                                                                         })
      visit new_user_session_path

      click_on 'Sign in with Google'

      expect(page).to have_content 'Successfully authenticated from Google account.'
    end
  end
end
