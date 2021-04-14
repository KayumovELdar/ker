class Reward < ApplicationRecord
  belongs_to :question
  has_one :reward_owning
  has_one :user, through: :reward_owning

  validates :title,:img_url, presence: true
end
