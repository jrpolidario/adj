LiveRecord.Model.create(
  {
    modelName: 'Game',
    hasMany: {
      players: { foreignKey: 'game_id', modelName: 'Player' }
    }
  }
)
