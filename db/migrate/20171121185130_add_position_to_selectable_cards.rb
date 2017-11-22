class AddPositionToSelectableCards < ActiveRecord::Migration[5.1]
  def change
    add_column :selectable_cards, :position, :integer, null: false
  end
end
