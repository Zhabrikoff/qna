# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/new_answer_mailer
class NewAnswerMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/new_answer_mailer/new_answer
  def new_answer
    NewAnswerMailer.new_answer
  end
end
