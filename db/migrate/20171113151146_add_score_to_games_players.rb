class AddScoreToGamesPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :games_players, :score, :integer
  end
end
