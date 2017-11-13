class CreateGamesPlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :games_players do |t|
      t.belongs_to :game, foreign_key: true
      t.belongs_to :player, foreign_key: true
      t.integer :selected_card_id

      t.timestamps
    end
    add_index :games_players, :selected_card_id
  end
end
