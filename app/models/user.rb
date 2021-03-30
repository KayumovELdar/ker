class User < ApplicationRecord
  has_many :questions
  has_many :answers

  has_many :badge_ownings, dependent: :destroy
  has_many :rewards, through: :badge_owning

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author?(content)
    id == content.user_id
  end
end
