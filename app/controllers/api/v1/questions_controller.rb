class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource
  before_action :current_resource_owner, only: :create

  def index
    respond_with Question.all, each_serializer: QuestionsListSerializer
  end

  def show
    respond_with Question.find(params[:id]), serializer: SingleQuestionSerializer
  end

  def create
    respond_with @current_resource_owner.questions.create(question_params), serializer: SingleQuestionSerializer
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end