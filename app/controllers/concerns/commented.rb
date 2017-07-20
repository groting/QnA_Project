module Commented
  extend ActiveSupport::Concern

    included do
    before_action :set_commentable, only: [:create_comment]
    end

    def create_comment
      @comment = Comment.new(commentable: @commentable, user_id: current_user.id,
                           body: comment_params[:body])
      @comment.save
      render 'comments/create'
    end

    private

    def model_klass
      controller_name.classify.constantize
    end

    def set_commentable
      @commentable = model_klass.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:body)
    end
end