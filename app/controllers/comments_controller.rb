class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
  end

  def destroy
    @comment = Comment.find(params[:id]) 
    if current_user.author_of?(@comment)
      @comment.destroy
    end
  end
  
end