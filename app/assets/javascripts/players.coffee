LiveRecord.Model.create(
  {
    modelName: 'Player',
    belongsTo: {
      games: { foreignKey: 'game_id', modelName: 'Game' }
    }
  }
)
