LiveRecord.Model.create(
  {
    modelName: 'Comment',
    belongsTo: {
      player: { foreignKey: 'player_id', modelName: 'Player' }
    }
  }
)
