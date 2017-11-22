class RenameIsFrontSideUpToIsSelectedFromSelectableCards < ActiveRecord::Migration[5.1]
  def change
    rename_column :selectable_cards, :is_front_side_up, :is_selected
  end
end
