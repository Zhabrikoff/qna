# frozen_string_literal: true

require 'rails_helper'

feature 'User can view a list of questions', "
  In order to see all questions
  As an authorized or unauthorized user
  I'd like to see a list of questions
" do
  given!(:questions) { create_list(:question, 5) }

  scenario 'All users can view questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
