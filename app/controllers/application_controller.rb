class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  check_authorization unless: :devise_controller?

  # current player refers to non-logged-in users, but those who entered a player name
  def current_player
    @current_player ||= Player.find_by(id: request.session[:player_id])
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, current_player)
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json do
        head :forbidden, content_type: 'text/html'
      end

      format.html do
        render 'games/index'
      end
    end
  end
end
