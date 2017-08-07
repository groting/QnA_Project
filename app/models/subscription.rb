class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :question
  validates :user_id, presence: true, uniqueness: { scope: :user_id }
  validates :question_id, presence: true
end
