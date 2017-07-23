class QuestionsController < ApplicationController
  include Voted
  include Commented
  
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :destroy]
  after_action  :stream_question, only: [:create]

  respond_to :js
  
  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new    
    respond_with(@question = current_user.questions.new)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
      respond_with @question
    else
      redirect_to questions_path,
        alert: 'You do not have permission to update this question'
    end
  end

  def destroy
    if current_user.author_of?(@question)
      respond_with(@question.destroy)
    else
      redirect_to questions_path, alert: 'You do not have permission to delete this question'
    end 
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end

  def stream_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(json: @question)
    )
  end
end
