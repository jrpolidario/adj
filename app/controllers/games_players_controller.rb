class GamesPlayersController < ApplicationController
  before_action :set_games_player, only: [:show, :edit, :update, :destroy]

  # GET /games_players
  # GET /games_players.json
  def index
    @games_players = GamesPlayer.all
  end

  # GET /games_players/1
  # GET /games_players/1.json
  def show
  end

  # GET /games_players/new
  def new
    @games_player = GamesPlayer.new
  end

  # GET /games_players/1/edit
  def edit
  end

  # POST /games_players
  # POST /games_players.json
  def create
    @games_player = GamesPlayer.new(games_player_params)

    respond_to do |format|
      if @games_player.save
        format.html { redirect_to @games_player, notice: 'Games player was successfully created.' }
        format.json { render :show, status: :created, location: @games_player }
      else
        format.html { render :new }
        format.json { render json: @games_player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games_players/1
  # PATCH/PUT /games_players/1.json
  def update
    respond_to do |format|
      if @games_player.update(games_player_params)
        format.html { redirect_to @games_player, notice: 'Games player was successfully updated.' }
        format.json { render :show, status: :ok, location: @games_player }
      else
        format.html { render :edit }
        format.json { render json: @games_player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games_players/1
  # DELETE /games_players/1.json
  def destroy
    @games_player.destroy
    respond_to do |format|
      format.html { redirect_to games_players_url, notice: 'Games player was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_games_player
      @games_player = GamesPlayer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def games_player_params
      params.require(:games_player).permit(:game_id, :player_id, :selected_card_id)
    end
end
