class AddIsFrontSideUpToSelectableCards < ActiveRecord::Migration[5.1]
  def change
    add_column :selectable_cards, :is_front_side_up, :boolean, null: false, default: false
  end
end
