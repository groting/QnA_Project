class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :best_order, -> {order('best DESC')}

  def select_best
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
