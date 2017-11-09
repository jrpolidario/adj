LiveRecord.Model.create(
  {
    modelName: 'Player',
    belongsTo: {
      game: { foreignKey: 'game_id', modelName: 'Game' }
    }
  }
)
