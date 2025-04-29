# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewAnswerMailer, type: :mailer do
  describe 'new_answer' do
    let(:user) { create(:user, email: 'to@example.org') }
    let(:question) { create(:question, title: 'Test Question') }
    let(:answer) { create(:answer, question: question) }
    let(:mail) { NewAnswerMailer.new_answer(user, answer) }

    it 'renders the headers' do
      expect(mail.subject).to eq("New answer to #{question.title}")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end
