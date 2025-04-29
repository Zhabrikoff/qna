# frozen_string_literal: true

class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :rating, :best, :user_id, :created_at, :updated_at

  has_many :comments
  has_many :files
  has_many :links

  belongs_to :user
end
