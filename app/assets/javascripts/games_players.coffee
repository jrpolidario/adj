LiveRecord.Model.create(
  {
    modelName: 'GamesPlayer',
    belongsTo: {
      game: { foreignKey: 'game_id', modelName: 'Game' },
      player: { foreignKey: 'player_id', modelName: 'Player' }
    }
  }
)
