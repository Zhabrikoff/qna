# frozen_string_literal: true

class Award < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :question

  has_one_attached :image

  validates :name, presence: true

  validate :validate_image_type, if: :image_attached?

  private

  def image_attached?
    image.attached?
  end

  def validate_image_type
    return if image.content_type.in?(%w[image/png image/jpg image/jpeg])

    errors.add(:image, 'should be a PNG, JPG or JPEG file')
  end
end
