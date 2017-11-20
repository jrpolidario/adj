LiveRecord.Model.create(
  {
    modelName: 'Player',
    hasMany: {
      gamesPlayers: { foreignKey: 'player_id', modelName: 'GamesPlayer' },
      comments: { foreignKey: 'player_id', modelName: 'Comment' }
    }
    instanceMethods: {
      games: () ->
        games = []
        this.gamesPlayers().map((gamePlayer) ->
          gamePlayer.game()
          games.push(gamePlayer.game())
        )
        return games

      hasGame: (game) ->
        return this.games().indexOf(game) != -1
    }
  }
)
