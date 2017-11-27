class Game < ApplicationRecord
  INACTIVE_TIME = 10.minute
  NUMBER_OF_DECK_CARDS = 24
  NUMBER_OF_SELECTABLE_CARDS = 4

  has_many :live_record_updates, as: :recordable, dependent: :destroy
  has_many :games_players, dependent: :destroy
  has_many :players, through: :games_players
  has_many :selectable_cards, dependent: :destroy # this refers to the 4 cards a player can choose
  has_many :deck_cards, dependent: :destroy # this refers to cards in the deck
  belongs_to :current_turn_games_player, class_name: 'GamesPlayer', required: false # player who currently has the turn

  accepts_nested_attributes_for :games_players, reject_if: :all_blank

  scope :ongoing, -> { where.has{ (updated_at > INACTIVE_TIME.ago) & (is_finished == false) } }

  has_secure_password

  after_create :populate_deck_cards
  # after_update_commit :populate_selectable_cards, if: -> { is_started_changed? && is_started }

  include LiveRecord::Model::Callbacks

  def self.live_record_whitelisted_attributes(game, current_player)
    # only allow fetching of ongoing records
    # if ongoing.exists?(id: game.id)
      [:id, :current_turn_games_player_id, :is_finished, :is_started, :games_players_turn_sequence, :created_at, :updated_at]
    # else
    #   []
    # end
  end

  def self.live_record_queryable_attributes(current_player)
    [:is_finished, :is_started, :updated_at]
  end

  def start!
    populate_selectable_cards

    self.is_started = true

    # designate the order of the players
    grouped_games_players = games_players.group_by(&:team)

    self.games_players_turn_sequence = []

    # To determine the sequence of players' turns, let's take a random player in each team
    while !grouped_games_players.empty?
      grouped_games_players.each do |team, games_players|
        games_player = games_players.sample

        self.games_players_turn_sequence << games_player.id
        games_players.delete(games_player)
        grouped_games_players.delete(team) if games_players.empty?
      end
    end

    set_next_turn_games_player

    save!
  end

  def set_next_turn_games_player
    if current_turn_games_player_id.nil? || current_turn_games_player_id == games_players_turn_sequence.last
      self.current_turn_games_player_id = games_players_turn_sequence.first
    else
      next_index = games_players_turn_sequence.index(current_turn_games_player_id) + 1
      self.current_turn_games_player_id = games_players_turn_sequence[next_index]
    end
  end

  def take_a_selectable_card_from_deck_cards
    random_deck_card = deck_cards.order('RANDOM()').take

    if random_deck_card.present?
      current_card_positions = selectable_cards.pluck(:position)
      available_card_positions = (1..NUMBER_OF_SELECTABLE_CARDS).to_a - current_card_positions

      selectable_card = SelectableCard.new(
        card: random_deck_card.card,
        position: available_card_positions.sample,
      )
      selectable_cards << selectable_card

      random_deck_card.destroy
      selectable_card
    end
  end

  private

  def populate_deck_cards
    random_cards = Card.order('RANDOM()').limit(NUMBER_OF_DECK_CARDS)

    random_cards.each do |random_card|
      deck_cards << DeckCard.new(card: random_card)
    end
  end

  def populate_selectable_cards
    Thread.new do
      sleep(1)
      NUMBER_OF_SELECTABLE_CARDS.times do
        take_a_selectable_card_from_deck_cards
        sleep(1)
      end
    end
  end
end
