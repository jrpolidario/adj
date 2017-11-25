class AddIsBombToSelectableCards < ActiveRecord::Migration[5.1]
  def change
    add_column :selectable_cards, :is_bomb, :boolean, null: false, default: false
  end
end
