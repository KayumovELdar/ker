class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: %i[create update destroy]
  before_action :answer, except: %i[create]
  authorize_resource
  after_action :publish_answer, only: %i[create]

  def create
    @answer = current_user.answers.build(answer_params)
    @answer.question = question
    @answer.save
    @comment = Comment.new
    @answer.save
  end

  def update
    if current_user&.author?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    end
  end

  def destroy
    @answer.destroy if current_user.author?(@answer)
  end

  def set_best
    @answer.set_best if current_user&.author?(@answer.question)
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer_files_array
    @answer.files.map do |file|
      [file.filename.to_s , url_for(file),file.id]
    end
  end

  def answer_links_array
    @answer.links.map do |link|
      [link.name, link.url]
    end
  end

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
      "questions/#{params[:question_id]}/answers",
        answer: @answer,
        files: answer_files_array,
        links: answer_links_array
    )
  end

  def answer_params
    params.require(:answer).permit(:title, :body, files: [],links_attributes: [:name, :url, :_destroy])
  end
end
