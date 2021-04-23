class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: %i[index create]
  before_action :set_answer, only: %i[show destroy]

  def index
    authorize! :index, @question
    @answers = @question.answers
    render json: @answers, each_serializer: AnswersSerializer, root: "answers"
  end

  def show
    authorize! :show, @answer
    render json: @answer, serializer: AnswerSerializer
  end

  def create
    authorize! :create, Answer
    @answer = current_resource_owner.answers.build(answer_params)
    @answer.question = @question
    if @answer.save
      render json: @answer, serializer: AnswerSerializer
    end
  end

  def destroy
   authorize! :destroy, @answer
   @answer.destroy
   render json: { message: "answer deleted", status: 200 }
 end


  private

  def set_question
    @question ||= Question.find(params[:question_id])
  end

  def set_answer
    @answer ||= Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body,
                                   files: [],
                                   links_attributes: [:name, :url])
  end
end
