class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  
  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = current_user.questions.new
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if current_user.author_of?(@question)
      if @question.update(question_params)
        redirect_to @question
      else
        render :edit
      end
    else
      redirect_to questions_path,
      notice: 'You do not have permission to update this question'
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      flash[:notice] = 'Your question successfully deleted'
    else
      flash[:notice] = 'You do not have permission to delete this question'
    end
    redirect_to questions_path
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
