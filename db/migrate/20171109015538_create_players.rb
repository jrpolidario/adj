class CreatePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.integer :score
      t.string :name
      t.belongs_to :game, foreign_key: true

      t.timestamps
    end
  end
end
