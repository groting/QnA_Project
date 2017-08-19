class Answer < ApplicationRecord
  include Votable
  include Commentable
  
  belongs_to :question, touch: true
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  scope :best_order, -> {order('best DESC')}

  after_create :notify_subscribers
  after_create :create_subscription_for_author

  def select_best
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end

  private

  def notify_subscribers
    AnswerNoticeJob.perform_later(self)
  end

  def create_subscription_for_author
    Subscription.find_or_initialize_by(user: self.user, question: self.question)
  end
end
