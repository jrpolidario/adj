class CreateCards < ActiveRecord::Migration[5.1]
  def change
    create_table :cards do |t|
      t.belongs_to :category, foreign_key: true
      t.string :name
      t.string :image

      t.timestamps
    end
  end
end
