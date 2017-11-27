class GamesPlayer < ApplicationRecord

  include LiveRecord::Model::Callbacks
  belongs_to :game, touch: true
  belongs_to :player
  has_many :live_record_updates, as: :recordable, dependent: :destroy

  attr_accessor :game_password

  validates :game, uniqueness: { scope: :player }
  validates :game_password, presence: true, on: :create, if: -> { game.persisted? }
  validate on: :create, if: -> { game.persisted? && game_password.present? } do
    if !game.authenticate(game_password)
      errors.add(:game_password, 'Sorry, wrong password. Please try again.')
    end
  end

  validate on: :update, if: -> { game.is_started? } do
    error_message = 'can no longer be updated after game has started'
    errors.add(:is_ready, error_message) if is_ready_changed?
    errors.add(:team, error_message) if team_changed?
  end

  after_update :check_all_players_are_ready_and_min_of_2_per_team_then_start_game!

  def self.live_record_whitelisted_attributes(games_player, current_player)
    [:id, :game_id, :player_id, :is_ready, :score, :team, :created_at, :updated_at]
  end

  def self.live_record_queryable_attributes(current_player)
    [:id, :game_id, :player_id, :is_ready, :score, :team, :created_at, :updated_at]
  end

  private

  def check_all_players_are_ready_and_min_of_2_per_team_then_start_game!
    if is_ready_changed? && is_ready
      unless game.games_players.where(is_ready: false).exists?
        teams_count = game.games_players.group(:team).count
        if teams_count.all? { |k, v| v >= 2 }
          game.update!(is_started: true)
        end
      end
    end
  end
end
