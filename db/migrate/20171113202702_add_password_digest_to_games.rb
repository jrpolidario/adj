class AddPasswordDigestToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :password_digest, :string
  end
end
