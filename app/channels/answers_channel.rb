# frozen_string_literal: true

class AnswersChannel < ApplicationCable::Channel
  def follow
    stream_from "questions/#{params[:question_id]}"
  end
end
