class AddIsAdminToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :is_admin, :boolean
    add_index :users, :is_admin
  end
end
