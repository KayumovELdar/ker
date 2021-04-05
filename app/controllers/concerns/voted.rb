module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_up, vote_down, cancel_vote]
  end

  def vote_up
    @votable.up(current_user)
    render json: { id: @votable.id, rating: @votable.rating }
  end

  def vote_down
    @votable.down(current_user)
    render json: { id: @votable.id, rating: @votable.rating }
  end

  def cancel_vote
    @votable.cancel_vote_of(current_user)
    render json: { id: @votable.id, rating: @votable.rating }
  end

  private


  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable ||= model_klass.find(params[:id])
  end

end
