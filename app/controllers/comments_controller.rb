class CommentsController < ApplicationController
  before_action :authenticate_user!

  respond_to :js

  def create
  end

  def destroy
    @comment = Comment.find(params[:id]) 
    if current_user.author_of?(@comment)
      respond_with(@comment.destroy)
    end
  end
  
end