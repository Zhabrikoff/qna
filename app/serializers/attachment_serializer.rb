# frozen_string_literal: true

class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :filename, :url

  def url
    Rails.application.routes.url_helpers.rails_blob_path(object.blob, only_path: true)
  end
end
