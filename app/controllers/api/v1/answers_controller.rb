class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: [:index, :create]

  authorize_resource

  def index
    respond_with @question.answers, each_serializer: AnswersListSerializer
  end

  def show
    respond_with Answer.find(params[:id]), serializer: SingleAnswerSerializer
  end

  def create
    respond_with(@question.answers.create(answer_params.merge(user: current_resource_owner)),
      serializer: SingleAnswerSerializer)
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end