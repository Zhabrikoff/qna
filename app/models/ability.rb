# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    guest_abilities
    return unless user.present?

    user_abilities
    return unless user.admin?

    admin_abilities
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    content_creation_abilities
    content_management_abilities
    voting_abilities
    attachment_abilities
  end

  def content_creation_abilities
    can :create, [Question, Answer, Comment]
  end

  def content_management_abilities
    can %i[update destroy], [Question, Answer, Comment], { user_id: user.id }

    can [:create, :update, :destroy], Link do |link|
      user_owns_linkable?(link)
    end
  end

  def voting_abilities
    can [:vote_up, :vote_down], [Question, Answer] do |votable|
      not_own_votable?(votable)
    end

    can :mark_as_best, Answer do |answer|
      user_owns_question?(answer)
    end
  end

  def attachment_abilities
    can :destroy, ActiveStorage::Attachment do |attachment|
      user_owns_attachment?(attachment)
    end
  end

  def admin_abilities
    can :manage, :all
  end

  private

  def user_owns_linkable?(link)
    link.linkable.user_id == user.id
  end

  def not_own_votable?(votable)
    votable.user_id != user.id
  end

  def user_owns_question?(answer)
    answer.question.user_id == user.id
  end

  def user_owns_attachment?(attachment)
    user.author?(attachment.record)
  end
end
