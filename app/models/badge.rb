class Badge < ApplicationRecord

  belongs_to :question

  has_one :badge_owning, dependent: :destroy
  has_one :user, through: :badge_owning

  validates :title, presence: true
  validates :image_url, presence: true

  def badge_the_user(answer_user)
    self.user = answer_user
  end
end
