# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def show; end
end
