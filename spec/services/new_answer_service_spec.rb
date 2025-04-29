# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewAnswerService do
  let(:users) { create_list(:user, 3) }
  let(:question) { create(:question, user: users.first) }
  let(:answer) { create(:answer, question: question, user: users.last) }
  let(:subscription) { create(:subscription, user: users.first, question: question) }
  let(:other_subscription) { create(:subscription, user: users.last, question: question) }

  it 'sends new answer notification to all users' do
    allow(NewAnswerMailer).to receive(:new_answer).with(users.first, answer).and_call_original
    allow(NewAnswerMailer).to receive(:new_answer).with(users.last, answer).and_call_original

    subject.send_notification(answer)
  end
end
