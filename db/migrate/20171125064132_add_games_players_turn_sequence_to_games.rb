class AddGamesPlayersTurnSequenceToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :games_players_turn_sequence, :integer, array: true, default: []
  end
end
