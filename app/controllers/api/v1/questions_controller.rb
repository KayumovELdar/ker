class Api::V1::QuestionsController < Api::V1::BaseController
    before_action :set_question, only: %i[answers show]

  def index
    authorize! :index, Question
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer, root: "questions"
  end

  def show
    authorize! :show, @question
    render json: @question, serializer: QuestionSerializer
  end

  private

  def set_question
    @question ||= Question.find(params[:id])
  end
end
