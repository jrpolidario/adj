LiveRecord.Model.create(
  {
    modelName: 'Player',
    hasMany: {
      gamesPlayers: { foreignKey: 'player_id', modelName: 'GamesPlayer' }
    }
  }
)
