class Answer < ApplicationRecord
  belong_to :question

  validates :title, :body, presence: true
end
