class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def admin_abilities
    can :manage, :all
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer, Comment], user_id: user.id
    can :destroy, Attachment do |attachment|
      user.author_of?(attachment.attachable)
    end

    can :select_best, Answer, question: { user_id: user.id  }
    can :create_comment, :all

    can [:like, :dislike, :clear_vote], Answer do |answer|
      !user.author_of?(answer)
    end

    can [:like, :dislike, :clear_vote], Question do |question|
      !user.author_of?(question)
    end

    can :me, User
  end
end