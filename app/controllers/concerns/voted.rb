module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:like, :dislike, :clear_vote]
  end

  def like
    change_vote(:like)
  end
  
  def dislike
    change_vote(:dislike)
  end

  def clear_vote
    change_vote(:clear_vote)
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def change_vote(action)
    respond_to do |format|
      unless current_user.author_of?(@votable)
        @votable.public_send(action, current_user)
        @votable.vote(current_user)
        format.json { render json: { resource: controller_name.singularize ,
                                     votable: @votable,
                                     vote: @vote,
                                     vote_value: @vote&.show_value } } 
      else
        format.json { render json:
          { votable: @votable,
            resource: controller_name.singularize ,
            error: "You do not have permission to vote for this #{controller_name.singularize}" },
                      status: :forbidden }
        
      end
    end
  end
end