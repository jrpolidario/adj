class AddCurrentTurnGamesPlayerIdToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :current_turn_games_player_id, :integer
  end
end
