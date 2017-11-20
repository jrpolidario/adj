class AddDefaultAndNullForIsReadyAndIsStarted < ActiveRecord::Migration[5.1]
  def change
    change_column_null :games, :is_started, false, false
    change_column_default :games, :is_started, false
    change_column_null :games_players, :is_ready, false, false
    change_column_default :games_players, :is_ready, false

  end
end
