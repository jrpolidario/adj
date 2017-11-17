class AddIsReadyToGamesPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :games_players, :is_ready, :boolean
  end
end
