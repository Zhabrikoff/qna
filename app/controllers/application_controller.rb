# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |e|
    redirect_to root_path, alert: e.message
  end

  check_authorization unless: :devise_controller?
end
