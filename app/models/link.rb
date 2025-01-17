# frozen_string_literal: true

class Link < ApplicationRecord
  VALID_URL_FORMAT = %r{\A(http|https)://[^\s]+}i
  VALID_GIST_URL_FORMAT = %r{\Ahttps://gist.github.com/\w+}i

  belongs_to :linkable, polymorphic: true

  validates :url, presence: true, format: { with: VALID_URL_FORMAT }
  validates :name, presence: true

  def gist_url?
    VALID_GIST_URL_FORMAT.match?(url)
  end
end
