module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def like(user)
    return if voted_by?(user)
    transaction do
      votes.create!(value: 1, user: user)
      self.class.increment_counter(:rating, self)
      self.reload
    end
  end

  def dislike(user)
    return if voted_by?(user)
    transaction do
      votes.create!(value: -1, user: user)
      self.class.decrement_counter(:rating, self)
      self.reload
    end
  end

  def clear_vote(user)
    if voted_by?(user)
      transaction do
        if vote(user).value == 1
          self.class.decrement_counter(:rating, self)
        else
          self.class.increment_counter(:rating, self)
        end
        self.reload
        vote(user).destroy
      end
    end
  end

  def vote(user)
    votes.where(user: user).first if user
  end

  private

  def voted_by?(user)
    user.votes.exists?(votable_id: id, votable_type: self.class.name)
  end
end