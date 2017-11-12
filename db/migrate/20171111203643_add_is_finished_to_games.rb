class AddIsFinishedToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :is_finished, :boolean, null: false, default: false
    add_index :games, :is_finished
  end
end
