class AddTimestampIndexesToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_index :players, :created_at
    add_index :players, :updated_at
  end
end
