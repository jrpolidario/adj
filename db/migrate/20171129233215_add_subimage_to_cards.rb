class AddSubimageToCards < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :subimage, :string
  end
end
