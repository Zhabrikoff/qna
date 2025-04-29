# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      before_action :find_question, only: %i[show]
      before_action :find_owned_question, only: %i[update destroy]

      def index
        @questions = Question.all

        render json: @questions
      end

      def show
        render json: @question
      end

      def create
        @question = current_resource_owner.questions.new(question_params)

        if @question.save
          render json: @question, status: :created
        else
          render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @question.update(question_params)
          render json: @question
        else
          render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @question.destroy

        render json: { message: 'Question deleted' }
      end

      private

      def find_question
        @question = Question.find(params[:id])
      end

      def find_owned_question
        @question = current_resource_owner.questions.find_by(id: params[:id])

        render json: { error: 'Question not found' }, status: :not_found unless @question
      end

      def question_params
        params.require(:question).permit(:title, :body)
      end
    end
  end
end
