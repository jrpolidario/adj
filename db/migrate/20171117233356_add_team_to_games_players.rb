class AddTeamToGamesPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :games_players, :team, :integer
  end
end
