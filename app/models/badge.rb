class Badge < ApplicationRecord

  belongs_to :question

  validates :title, presence: true
  validates :image_url, presence: true
end
