class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, presence: true, numericality: {equal: -> { -1 || 1}}

  validate :cannot_author

  private

  def cannot_author
    errors.add(:user, 'can not be an author') if user&.author?(votable)
  end
end
