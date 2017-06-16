class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:destroy]
  before_action :set_question, only: [:create]
  

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
      redirect_to @question
    else
      flash[:notice] = 'Error prevent answer from saving.'
      redirect_to @question
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'Your answer successfully deleted'
    else
      redirect_to questions_path, notice: 'You do not have permission to delete this answer'
    end
  end


  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_answer
   @answer = Answer.find(params[:id])
  end
end
