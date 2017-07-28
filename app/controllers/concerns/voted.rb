module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:like, :dislike, :clear_vote]
  end

  def like
    authorize! :like, @votable
    change_vote(:like)   
  end
  
  def dislike
    authorize! :dislike, @votable
    change_vote(:dislike)
  end

  def clear_vote
    authorize! :clear_vote, @votable
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
      @votable.public_send(action, current_user)
      @votable.vote(current_user)
      format.json { render json: { resource: controller_name.singularize ,
                                   votable: @votable,
                                   vote: @vote,
                                   vote_value: @vote&.show_value } } 
    end
  end
end