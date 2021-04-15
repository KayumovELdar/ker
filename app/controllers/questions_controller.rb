class QuestionsController < ApplicationController

  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy ]
  authorize_resource
  after_action :publish_question, only: [:create]
  after_action :set_question_gon, only: [:create]
  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    @answer.links.new
    @comment = @question.comments.build(user: current_user)
  end

  def new
    @question.links.build
    @question.build_badge
  end

  def edit; end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

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
    if current_user.author?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question was successfully deleted!'
    else
      redirect_to questions_path, notice: 'Your question was not deleted!'
    end
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body,
                                      files: [],
                                      links_attributes: [:name, :url],
                                      badge_attributes: [:title, :image_url] )
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast('questions',{ question: @question, user_id: current_user.id })
  end

  def set_question_gon
    gon.question_id = question.id
  end
end
