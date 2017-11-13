class GamesPlayer < ApplicationRecord

  include LiveRecord::Model::Callbacks
  belongs_to :game, touch: true
  belongs_to :player
  has_many :live_record_updates, as: :recordable, dependent: :destroy

  def self.live_record_whitelisted_attributes(games_player, current_user)
    [:id, :game_id, :player_id, :score, :created_at, :updated_at]
  end

  def self.live_record_queryable_attributes(current_user)
    [:id, :game_id, :player_id, :score, :created_at, :updated_at]
  end
end
