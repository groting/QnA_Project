class AnswersController < ApplicationController
  before_action :load_question, only: [:create]
  

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
      redirect_to @question
    else
      flash[:notice] = 'Error prevent answer from saving.'
      redirect_to @question
    end
  end


  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
