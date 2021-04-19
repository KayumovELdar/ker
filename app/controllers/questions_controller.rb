class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show create update destroy]
  before_action :question, except: %i[create]
  authorize_resource
  after_action :publish_question, only: %i[create]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.build
    @comment = Comment.new
  end

  def edit; end

  def new
    @question.links.build
    @question.build_reward
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params) if current_user&.author?(@question)
  end

  def destroy
    if current_user&.author?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question was successfully deleted!'
    else
      redirect_to questions_path, notice: 'Your question was not deleted!'
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url], reward_attributes: [:title, :img_url])
  end

  def questions
    Question.all.map do |question|
      [question.id, question.title]
    end
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      title: @question.title,
      id: @question.id
    )
  end
end
