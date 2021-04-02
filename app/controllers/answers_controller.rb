class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: :create
  before_action :find_answer, only: %i[destroy update set_best]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save

    respond_to do |format|
      if @answer.save
        format.html {render @answer}
      else
        format.html do
          render partial: 'shared/errors', locals: { resource: @answer },
                              status: :unprocessable_entity
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
    @answer.set_best! if current_user&.author?(@answer.question)
  end

  private

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:title, :body, files: [], links_attributes: [:name, :url])
  end
end
