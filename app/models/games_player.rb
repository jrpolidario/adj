class GamesPlayer < ApplicationRecord

  include LiveRecord::Model::Callbacks
  belongs_to :game, touch: true
  belongs_to :player
  has_many :live_record_updates, as: :recordable, dependent: :destroy

  validates :game, uniqueness: { scope: :player }

  attr_accessor :game_password

  validates :game_password, presence: true, on: :create, if: -> { game.persisted? }
  validate on: :create, if: -> { game.persisted? && game_password.present? } do
    if !game.authenticate(game_password)
      errors.add(:game_password, 'Sorry, wrong password. Please try again.')
    end
  end

  def self.live_record_whitelisted_attributes(games_player, current_user)
    [:id, :game_id, :player_id, :score, :created_at, :updated_at]
  end

  def self.live_record_queryable_attributes(current_user)
    [:id, :game_id, :player_id, :score, :created_at, :updated_at]
  end
end
