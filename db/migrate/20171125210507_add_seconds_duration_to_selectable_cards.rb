class AddSecondsDurationToSelectableCards < ActiveRecord::Migration[5.1]
  def change
    add_column :selectable_cards, :seconds_duration, :integer
  end
end
