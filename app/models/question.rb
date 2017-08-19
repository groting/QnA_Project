class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  default_scope { order(:created_at) }

  scope :lastday, -> { where(updated_at: Time.current.yesterday.all_day) }

  after_create :create_subscrition_for_author

  private

  def create_subscrition_for_author
    Subscription.create(user: self.user, question: self)
  end
end
