class SelectableCard < ApplicationRecord
  DEFAULT_SECONDS_DURATION = 30
  CHANCE_TO_BECOME_A_BOMB = 20
  CHANCE_TO_BECOME_A_QUESTION = 10

  belongs_to :game, touch: true
  belongs_to :card

  has_many :live_record_updates, as: :recordable, dependent: :destroy

  before_create :chance_to_become_special
  before_create :set_seconds_duration_and_left
  before_create :set_score

  before_update :start_countdown!, if: -> { is_selected_changed? && is_selected }
  before_update :add_score_and_done!, if: -> { team_winner_changed? && team_winner.present? }
  after_update :remove_this_from_game, if: :is_done
  after_destroy :draw_new_card_and_set_next_turn_games_player

  include LiveRecord::Model::Callbacks

  def self.live_record_whitelisted_attributes(selectable_card, current_player)
    # if current_player && current_player.games.exists?(id: selectable_card.game.id)
      [:id, :card_id, :game_id, :position, :is_selected, :is_time_is_up, :seconds_left, :seconds_duration, :is_bomb, :is_question, :score, :team_winner, :is_done, :created_at, :updated_at]
    # else
    #   []
    # end
  end

  def self.live_record_queryable_attributes(current_user)
    [:game_id, :card_id, :created_at, :updated_at]
  end

  def chance_to_become_special
    self.is_bomb = rand(100) < CHANCE_TO_BECOME_A_BOMB
    self.is_question = rand(100) < CHANCE_TO_BECOME_A_QUESTION
  end

  def set_seconds_duration_and_left
    self.seconds_left = DEFAULT_SECONDS_DURATION
    self.seconds_left /= 2 if is_bomb
    self.seconds_duration = seconds_left
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

    self.is_done = true
  end

  def remove_this_from_game
    Thread.new do
      # lets wait 7 seconds before removing the card from the board, so they could have a glimpse of it
      sleep(7)
      self.destroy
      sleep(1)
    end
  end

  def draw_new_card_and_set_next_turn_games_player
    game.take_a_selectable_card_from_deck_cards!
    game.set_next_turn_games_player

    # check if no more cards to play, then declare winner
    if game.selectable_cards.count == 0
      game.is_finished = true
    end

    game.save!
  end
end
