LiveRecord.Model.create(
  {
    modelName: 'Game',
    belongsTo: {
      currentTurnGamesPlayer: { foreignKey: 'current_turn_games_player_id', modelName: 'GamesPlayer' }
    },
    hasMany: {
      gamesPlayers: { foreignKey: 'game_id', modelName: 'GamesPlayer' }
      selectableCards: { foreignKey: 'game_id', modelName: 'SelectableCard' }
    }
  }
)
