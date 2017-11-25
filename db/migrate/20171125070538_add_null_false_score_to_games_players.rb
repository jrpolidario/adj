class AddNullFalseScoreToGamesPlayers < ActiveRecord::Migration[5.1]
  def change
    change_column_null :games_players, :score, false, 0
  end
end
