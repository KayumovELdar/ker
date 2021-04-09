
class CommentsController < ApplicationController

  before_action :authenticate_user!, only: %i[ create ]
  before_action :commentable,        only: %i[ create ]

  def create
    respond_to do |format|
      @comment = current_user.comments.build(comment_params)
      @comment.commentable = @commentable

      if @comment.save
        format.json { render json: { comment: @comment, commentable: @comment.commentable } }
      end
    end
  end

  private

  def commentable
    @commentable ||= Question.find(params[:question_id]) if params[:question_id]
    @commentable ||= Answer.find(params[:answer_id]) if params[:answer_id]
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
