class AddTeamWinnerToSelectableCards < ActiveRecord::Migration[5.1]
  def change
    add_column :selectable_cards, :team_winner, :integer
  end
end
