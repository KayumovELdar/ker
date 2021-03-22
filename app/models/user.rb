class User < ApplicationRecord
  has_many :questions
  has_many :answers
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author?(content)
    id == content.user_id
  end
end
