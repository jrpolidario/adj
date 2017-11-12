class AddTimestampIndexesToGames < ActiveRecord::Migration[5.1]
  def change
    add_index :games, :created_at
    add_index :games, :updated_at
  end
end
