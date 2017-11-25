class AddIsTimeIsUpToSelectableCards < ActiveRecord::Migration[5.1]
  def change
    add_column :selectable_cards, :is_time_is_up, :boolean, null: false, default: false
  end
end
