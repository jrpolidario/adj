Game
has_many :players
has_many :deck_cards
has_many :selectable_cards
is_finished

Player
belongs_to :game
belongs_to :selected_card, class_name: 'Card'
score
name

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
