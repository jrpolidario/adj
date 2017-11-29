class AddImageSourceUrlToCards < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :image_source_url, :string
  end
end
