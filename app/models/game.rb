class Game < ApplicationRecord
  INACTIVE_TIME = 1.minute
  NUMBER_OF_DECK_CARDS = 50
  NUMBER_OF_SELECTABLE_CARDS = 4

  include LiveRecord::Model::Callbacks
  has_many :live_record_updates, as: :recordable, dependent: :destroy
  has_many :games_players, dependent: :destroy
  has_many :players, through: :games_players
  has_many :selectable_cards, dependent: :destroy # this refers to the 4 cards a player can choose
  has_many :deck_cards, dependent: :destroy # this refers to cards in the deck

  accepts_nested_attributes_for :games_players, reject_if: :all_blank

  scope :ongoing, -> { where.has{ (updated_at > INACTIVE_TIME.ago) & (is_finished == false) } }

  has_secure_password

  after_create :populate_deck_cards
  after_create :populate_selectable_cards

  def self.live_record_whitelisted_attributes(game, current_player)
    # only allow fetching of ongoing records
    # if ongoing.exists?(id: game.id)
      [:id, :is_finished, :is_started, :created_at, :updated_at]
    # else
    #   []
    # end
  end

  def self.live_record_queryable_attributes(current_player)
    [:is_finished, :is_started, :updated_at]
  end

  def start!
    update!(is_started: true)
  end

  private

  def populate_deck_cards
    transaction do
      random_cards = Card.order('RANDOM()').limit(NUMBER_OF_DECK_CARDS)

      random_cards.each do |random_card|
        deck_cards << DeckCard.new(card: random_card)
      end
    end
  end

  def populate_selectable_cards
    transaction do
      NUMBER_OF_SELECTABLE_CARDS.times do
        take_a_selectable_card_from_deck_cards
      end
    end
  end

  def take_a_selectable_card_from_deck_cards
    random_deck_card = deck_cards.order('RANDOM()').take

    selectable_cards << SelectableCard.new(card: random_deck_card.card)

    random_deck_card.destroy
  end
end
