class GamesPlayersController < ApplicationController
  before_action :set_game, only: [:create, :index, :new] # shallow nested routes
  before_action :set_player, only: [:create, :index, :new] # shallow nested routes
  before_action :set_games_player, only: [:show, :edit, :update, :destroy]
  authorize_resource

  def create
    @games_player = (@game || @player).games_players.new(games_player_params)
    @games_player.player = current_player

    respond_to do |format|
      if @games_player.save
        format.json { render :show, status: :created, location: @games_player }
      else
        format.json { render json: @games_player.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @games_player.update(games_player_params)
        format.json { render :show, status: :ok, location: @games_player }
      else
        format.json { render json: @games_player.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @games_player.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  def set_game
    @game = Game.find(params[:game_id]) if params[:game_id]
  end

  def set_player
    @player = Player.find(params[:player_id]) if params[:player_id]
  end

  def set_games_player
    @games_player = GamesPlayer.find(params[:id])
  end

  def games_player_params
    params.require(:games_player).permit(:game_id, :selected_card_id, :game_password, :team, :is_ready)
  end
end
