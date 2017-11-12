class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  check_authorization

  def current_user
    Player.find_by(id: request.session[:player_id])
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { render status: :forbidden, body: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end
end
