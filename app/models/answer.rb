class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  scope :best_order, -> {order('best DESC')}

  def select_best
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
