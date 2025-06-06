# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[destroy update mark_as_best]
  before_action :find_question_from_answer, only: %i[update mark_as_best]
  before_action :find_new_comment
  after_action :publish_answer, only: %i[create]

  authorize_resource

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @answer.destroy
  end

  def update
    @answer.update(answer_params)
  end

  def mark_as_best
    @answer.mark_as_best
  end

  private

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_question_from_answer
    @question = @answer.question
  end

  def find_new_comment
    @comment = Comment.new(commentable: @answer)
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "questions/#{@answer.question.id}",
      @answer.to_json
    )
  end
end
