class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :votes
  has_many :reward_ownings
  has_many :rewards, through: :reward_ownings
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author?(content)
    id == content.user_id
  end
end
