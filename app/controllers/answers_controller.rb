# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[destroy update mark_as_best]
  before_action :find_question_from_answer, only: %i[update mark_as_best]

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
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_question_from_answer
    @question = @answer.question
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
