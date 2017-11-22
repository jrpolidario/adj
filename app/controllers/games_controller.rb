class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]
  authorize_resource
  
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.json { render :show, status: :created, location: @game }
      else
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @game.update(game_params)
        format.json { render :show, status: :ok, location: @game }
      else
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # def destroy
  #   @game.destroy
  #   respond_to do |format|
  #     format.json { head :no_content }
  #   end
  # end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.fetch(:game, {}).permit(:password, :password_confirmation, games_players_attributes: [:player_id])
  end
end
