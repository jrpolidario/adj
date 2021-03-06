class Player < ApplicationRecord

  include LiveRecord::Model::Callbacks
  has_many :live_record_updates, as: :recordable, dependent: :destroy
  has_many :games_players
  has_many :games, through: :games_players
  has_many :comments

  validates :name, presence: true, length: { maximum: 12 }

  def self.live_record_whitelisted_attributes(player, current_player)
    [:id, :name, :created_at, :updated_at]
  end

  def self.live_record_queryable_attributes(current_player)
    [:id, :name, :created_at, :updated_at]
  end
end
