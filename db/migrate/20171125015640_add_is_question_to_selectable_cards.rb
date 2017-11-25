class AddIsQuestionToSelectableCards < ActiveRecord::Migration[5.1]
  def change
    add_column :selectable_cards, :is_question, :boolean, null: false, default: false
  end
end
