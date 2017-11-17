class AddIsStartedToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :is_started, :boolean
    add_index :games, :is_started
  end
end
