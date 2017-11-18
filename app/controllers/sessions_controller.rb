class SessionsController < ApplicationController
  authorize_resource

  def me
    @session = Session.find_by(session_id: session.id)
    render status: :not_found unless @session

    session_data = Marshal.load(Base64.decode64(@session.data))
    render json: public_session_data(session_data)
  end

  private

  def public_session_data(session_data)
    session_data.slice(
      'player_id',
      '_csrf_token'
    )
  end
end
