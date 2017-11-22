class AddScoreToCards < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :score, :integer
    change_column_null :cards, :score, false, 0
  end
end
