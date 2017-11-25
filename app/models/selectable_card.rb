class SelectableCard < ApplicationRecord
  DEFAULT_SECONDS_LEFT = 30
  CHANCE_TO_BECOME_A_BOMB = 20
  CHANCE_TO_BECOME_A_QUESTION = 10

  belongs_to :game, touch: true
  belongs_to :card

  include LiveRecord::Model::Callbacks
  has_many :live_record_updates, as: :recordable, dependent: :destroy

  before_create :chance_to_become_special
  before_create :set_seconds_left
  before_create :set_score

  before_update :start_countdown!, if: -> { is_selected_changed? && is_selected }
  before_update :add_score_and_done!, if: -> { team_winner_changed? && team_winner.present? }

  def self.live_record_whitelisted_attributes(selectable_card, current_user)
    [:id, :card_id, :game_id, :position, :is_selected, :is_time_is_up, :seconds_left, :is_bomb, :is_question, :score, :team_winner, :is_done, :created_at, :updated_at]
  end

  def self.live_record_queryable_attributes(current_user)
    [:game_id, :card_id, :created_at, :updated_at]
  end

  def chance_to_become_special
    self.is_bomb = rand(100) < CHANCE_TO_BECOME_A_BOMB
    self.is_question = rand(100) < CHANCE_TO_BECOME_A_QUESTION
  end

  def set_seconds_left
    self.seconds_left = DEFAULT_SECONDS_LEFT
    self.seconds_left /= 2 if is_bomb
  end

  def set_score
    self.score = card.score
    self.score += 2 if is_question
  end

  private

  def start_countdown!
    Thread.new do
      last_iteration_runtime = 0

      seconds_left.times do
        sleep_time = 1.0 - last_iteration_runtime
        sleep_time = 0 if sleep_time < 0
        sleep(sleep_time)
        start_time = Time.now

        break if self.reload.is_time_is_up
        self.seconds_left -= 1
        self.save!

        last_iteration_run_time = (Time.now - start_time).seconds
      end

      self.update!(is_time_is_up: true) unless self.is_time_is_up
    end
  end

  def add_score_and_done!
    # if there is a winner
    if team_winner != 0
      game.games_players.each do |games_player|
        if games_player.team == team_winner
          games_player.score += score
          games_player.save!
        end
      end
    end

    game.set_next_turn_games_player
    game.save!

    # TODO: fix LiveRecord: possible reason is @_changed_attributes something
    update!(is_selected: false, is_done: true)
    # self.is_selected = false
    # self.is_done = true
  end
end
