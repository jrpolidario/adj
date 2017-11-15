LiveRecord.Model.create(
  {
    modelName: 'Player',
    hasMany: {
      gamesPlayers: { foreignKey: 'player_id', modelName: 'GamesPlayer' }
    }
    instanceMethods: {
      games: () ->
        games = []
        this.gamesPlayers().map((gamePlayer) ->
          games.push(gamePlayer.game())
        )
        return games
    }
  }
)
