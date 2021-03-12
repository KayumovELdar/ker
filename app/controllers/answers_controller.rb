class AnswersController < ApplicationController
  before_action :authenticate_user!
  def new
  end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user=current_user

    if @answer.save
      redirect_to question, notice: 'Ответ сохранен.'
    else
      render "questions/show"
    end
  end

  private

  def question
    @question||= Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:title, :body)
  end
end
