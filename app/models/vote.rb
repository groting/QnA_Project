class Vote < ApplicationRecord
  belongs_to :votable, optional: true, polymorphic: true
  belongs_to :user

  validates :value, uniqueness: { scope: [:user_id, :votable_id, :votable_type] }

  def show_value
    { 1 => :like, -1 => :dislike}[value]
  end
end