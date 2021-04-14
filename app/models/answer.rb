class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :title, :body, presence: true

  def set_best
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      question.reward&.update(user: user)
    end
  end
end
