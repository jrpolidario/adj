class AddSecondsLeftToSelectableCards < ActiveRecord::Migration[5.1]
  def change
    add_column :selectable_cards, :seconds_left, :integer
    change_column_null :selectable_cards, :seconds_left, false, 0
  end
end
