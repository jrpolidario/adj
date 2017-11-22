LiveRecord.Model.create(
  {
    modelName: 'Game',
    hasMany: {
      gamesPlayers: { foreignKey: 'game_id', modelName: 'GamesPlayer' }
      selectableCards: { foreignKey: 'game_id', modelName: 'SelectableCard' }
    }
  }
)
