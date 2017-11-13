class RemoveGameIdFromPlayers < ActiveRecord::Migration[5.1]
  def change
    remove_column :players, :game_id, :bigint
  end
end
