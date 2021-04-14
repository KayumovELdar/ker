class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :title, :body, presence: true

  def set_best
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
