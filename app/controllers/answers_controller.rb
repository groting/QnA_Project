class AnswersController < ApplicationController
  include Voted
  before_action :authenticate_user!
  before_action :set_answer, only: [:destroy, :update, :select_best]
  before_action :set_question, only: [:create]
  

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    else
      redirect_to question_path(@answer.question), alert: 'You do not have permission to update this answer'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy  
    else
      redirect_to question_path(@answer.question), alert: 'You do not have permission to delete this answer'
    end 
  end

  def select_best
    if current_user.author_of?(@answer.question)
      @answer.select_best
    else
      redirect_to question_path(@answer.question),
      alert: 'You do not have permission to select best answer'
    end
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
end
