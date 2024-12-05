# frozen_string_literal: true

require 'rails_helper'

feature 'User can view a specific question and answers', "
  In order to see a specific question and answers
  As an authorized or unauthorized user
  I'd like to see a specific question and answers
" do
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  scenario 'User can view a specific question and answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
