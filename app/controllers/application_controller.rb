class ApplicationController < ActionController::Base
  before_action :gon_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :unauthorized }
      format.js { head :unauthorized }
      format.html { redirect_to :root, alert: exception.message }
    end
  end

  def gon_user
    gon.user_id = current_user&.id
  end

  check_authorization unless: :devise_controller?
end
