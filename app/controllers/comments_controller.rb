class CommentsController < ApplicationController
  before_action :authenticate_user!

  respond_to :js

  load_and_authorize_resource

  def create
  end

  def destroy
    respond_with(@comment.destroy)
  end  
end