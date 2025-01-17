# frozen_string_literal: true

require 'rails_helper'

feature 'User can assign an award to question', "
  In order to reward author of best answer in my question
  As an question's author
  I'd like to be able to assign an award
" do
  given(:user) { create(:user) }

  background do
    sign_in(user)

    visit new_question_path

    fill_in 'Title', with: 'Test title'
    fill_in 'Body', with: 'Test body'
    fill_in 'Award name', with: 'Test award'
  end

  scenario 'User assigns an award when asking a question' do
    attach_file 'Image', "#{Rails.root}/spec/auxiliary/award.png"

    click_on 'Ask'

    expect(page).to have_content 'Test award'
  end

  scenario 'User assigns an award without an image when asking a question' do
    click_on 'Ask'

    expect(page).to have_content 'Award image must be attached'
  end
end
