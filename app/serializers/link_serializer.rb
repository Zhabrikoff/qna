# frozen_string_literal: true

class LinkSerializer < ActiveModel::Serializer
  attributes :id, :name, :url
end
