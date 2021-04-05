module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def up(user)
    votes.create(user: user, value: 1) unless votes.exists?(user: user)
  end

  def down(user)
    votes.create(user: user, value: -1) unless votes.exists?(user: user)
  end

  def cancel_vote_of(user)
    votes.find_by(user: user).destroy
  end

  def rating
    votes.sum(:value)
  end
end
