# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment], { user_id: user.id }
    can [:update,:destroy], [Question, Answer], { user_id: user.id }

    can :destroy, Link do |link|
      user.author?(link.linkable)
    end

    can :destroy, ActiveStorage::Attachment do |file|
      user.author?(file.record)
    end

    can [:vote_for, :vote_against], [Answer, Question] do |votable|
      !user.author?(votable)
    end

    can :cancel_vote, [Answer, Question] do |votable|
      user.author?(votable)
    end

    can :me, User do |profile|
      profile.id == user.id
    end

    can :set_best, Answer do  |answer|
      user.author?(answer.question)
    end
  end
end
