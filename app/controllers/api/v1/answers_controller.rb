# frozen_string_literal: true

module Api
  module V1
    class AnswersController < Api::V1::BaseController
      before_action :find_answer, only: %i[show]
      before_action :find_owned_answer, only: %i[update destroy]
      before_action :find_question, only: %i[index create]

      def index
        render json: @question.answers
      end

      def show
        render json: @answer
      end

      def create
        @answer = @question.answers.new(answer_params)
        @answer.user = current_resource_owner

        if @answer.save
          render json: @answer, status: :created
        else
          render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @answer.update(answer_params)
          render json: @answer
        else
          render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @answer.destroy

        render json: { message: 'Answer deleted' }
      end

      private

      def find_answer
        @answer = Answer.find(params[:id])
      end

      def find_owned_answer
        @answer = current_resource_owner.answers.find_by(id: params[:id])

        render json: { error: 'Answer not found' }, status: :not_found unless @answer
      end

      def find_question
        @question = Question.find(params[:question_id])
      end

      def answer_params
        params.require(:answer).permit(:body)
      end
    end
  end
end
