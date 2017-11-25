class AddDefaultScoreToGamesPlayers < ActiveRecord::Migration[5.1]
  def change
    change_column_default :games_players, :score, 0
  end
end
