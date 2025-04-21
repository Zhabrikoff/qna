# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show edit update destroy]
  before_action :find_new_comment
  after_action :publish_question, only: %i[create]

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    gon.question_id = @question.id
    @answer = Answer.new(question: @question)
    @answer.links.new
  end

  def new
    @question = current_user.questions.new
    @question.links.new
    @question.build_award
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy

    redirect_to questions_path
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def find_new_comment
    @comment = Comment.new(commentable: @question)
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[name url _destroy], award_attributes: %i[name image])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      @question.to_json
    )
  end
end
