# frozen_string_literal: true

class FindForOauthService
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    return existing_user if existing_user

    user = find_or_create_user
    user.create_authorization(auth)
    user
  end

  private

  def existing_user
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first

    authorization&.user
  end

  def find_or_create_user
    User.find_or_create_by(email: auth.info[:email]) do |u|
      password = Devise.friendly_token[0, 20]
      u.password = password
      u.password_confirmation = password
    end
  end
end
