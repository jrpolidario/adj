LiveRecord.Model.create(
  {
    modelName: 'Game',
    hasMany: {
      gamesPlayers: { foreignKey: 'game_id', modelName: 'GamesPlayer' }
    }
  }
)
