module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    # should be current_player, but LiveRecord references `current_user`
    def current_user
      Player.find_by(id: request.session[:player_id])
    end
  end
end
