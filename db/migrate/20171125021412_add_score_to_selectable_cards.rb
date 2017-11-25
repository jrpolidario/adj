class AddScoreToSelectableCards < ActiveRecord::Migration[5.1]
  def change
    add_column :selectable_cards, :score, :integer
    change_column_null :selectable_cards, :score, false, 3
  end
end
