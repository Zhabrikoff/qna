# frozen_string_literal: true

class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :email, :admin
end
