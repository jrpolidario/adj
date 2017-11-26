LiveRecord.Model.create(
  {
    modelName: 'DeckCard'
    belongsTo: {
      game: { foreignKey: 'game_id', modelName: 'Game' }
      card: { foreignKey: 'card_id', modelName: 'Card' }
    }
  }
)
