class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: :destroy

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to question, notice: 'Ответ сохранен.'
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'Your answer was successfully delete.'
    else
      redirect_to question_path(@answer.question), notice: 'Answer was not delete.'
    end
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:title, :body)
  end
end
