class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!
  before_action :set_answer, only: [:destroy, :update, :select_best]
  before_action :set_question, only: [:create]
  after_action  :stream_answer, only: [:create]

  authorize_resource

  respond_to :js
  respond_to :json, only: :create
  

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    respond_with(@answer.destroy)  
  end

  def select_best
    @answer.select_best
  end


  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end

  def set_answer
   @answer = Answer.find(params[:id])
  end

  def stream_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
      "question_#{@question.id}_answers",
      ApplicationController.render(json: { question: @question,
                                           answer: @answer})
    )
  end
end
