class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: %i[create update destroy]
  before_action :answer, only: %i[destroy update set_best]

  def create
    @answer = current_user.answers.build(answer_params)
    @answer.question = question
    respond_to do |format|
      if @answer.save
        format.json do
          render json: { answer: @answer,  links: @answer.links, files: answer_files_array }
        end
      else
        format.json do
          render json: @answer.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
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
      [file.filename.to_s , url_for(file)]
    end
  end

  def answer_params
    params.require(:answer).permit(:title, :body, files: [],links_attributes: [:name, :url, :_destroy])
  end
end
