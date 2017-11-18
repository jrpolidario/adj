Game
has_many :games_players
has_many :players, through: :games_players
has_many :deck_cards
has_many :selectable_cards
is_finished

Player
name

GamesPlayer
belongs_to :game
belongs_to :player
belongs_to :selected_card, class_name: 'Card'
team
score

SelectableCard
belongs_to :game
belongs_to :card

DeckCard
belongs_to :game
belongs_to :card

Card
belongs_to :category
name
image

Category
has_many :cards
name
