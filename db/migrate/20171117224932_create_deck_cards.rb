class CreateDeckCards < ActiveRecord::Migration[5.1]
  def change
    create_table :deck_cards do |t|
      t.belongs_to :game, foreign_key: true
      t.belongs_to :card, foreign_key: true

      t.timestamps
    end
  end
end
