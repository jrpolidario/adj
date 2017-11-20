class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.text :content
      t.belongs_to :player, foreign_key: true

      t.datetime :created_at, index: true
      t.datetime :updated_at, index: true
    end
  end
end
