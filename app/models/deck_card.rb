class DeckCard < ApplicationRecord
  belongs_to :game
  belongs_to :card

  include LiveRecord::Model::Callbacks
  has_many :live_record_updates, as: :recordable, dependent: :destroy

  def self.live_record_whitelisted_attributes(deck_card, current_player)
    if current_player && current_player.games.exists?(id: deck_card.game.id)
      [:id, :game_id, :card_id]
    else
      []
    end
  end

  def self.live_record_queryable_attributes(current_user)
    # This method only applies when not using `ransack` gem!
    # If you're using ransack gem, instead of this method, use one or more of the ransack methods:
    # see https://github.com/activerecord-hackery/ransack#authorization-whitelistingblacklisting
    #
    # Add attributes to this array that you would like current_user client to be able to query upon when "subscribing"
    # Defaults to empty array, thereby blocking everything by default, only unless explicitly stated here so.
    # i.e. if a current_user client subscribes to "new records creation" using `.subscribe({where: {...}})`,
    # then only these attributes will be considered in the "{where: ...}" argument
    # if you're using `ransack` gem, use `ransackable_attributes`
    # Empty array means unauthorized
    # Example:
    # [:id, :email, :name, :is_admin, :group_id, :created_at, :updated_at]
    [:game_id, :card_id]
  end
end
