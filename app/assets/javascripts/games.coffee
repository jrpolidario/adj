LiveRecord.Model.create(
  {
    modelName: 'Game',
    belongsTo: {
      currentTurnGamesPlayer: { foreignKey: 'current_turn_games_player_id', modelName: 'GamesPlayer' }
    },
    hasMany: {
      gamesPlayers: { foreignKey: 'game_id', modelName: 'GamesPlayer' }
      selectableCards: { foreignKey: 'game_id', modelName: 'SelectableCard' }
      deckCards: { foreignKey: 'game_id', modelName: 'DeckCard' }
    },
    instanceMethods: {
      currentSelectableCard: ->
        this.selectableCards().find((selectableCard) ->
          selectableCard.attributes.is_selected
        )
      teamsAndScores: ->
        teamsAndScores = []
        teamsAccountedFor = []
        this.gamesPlayers().forEach((gamesPlayer) ->
          if !teamsAccountedFor.includes(gamesPlayer.team())
            teamsAndScores.push([gamesPlayer.team(), gamesPlayer.score()])
            teamsAccountedFor.push(gamesPlayer.team())
        )
        teamsAndScores.sort((teamAndScoreLeft, teamAndScoreRight) ->
          teamAndScoreLeft[1] - teamAndScoreRight[1]
        )
        teamsAndScores
      winner: ->
        this.teamsAndScores()[0]
      teamScore: (team) ->
        matchingTeamAndScore = this.teamsAndScores().find((teamAndScore) ->
          team == teamAndScore[0]
        )
        matchingTeamAndScore[1] if matchingTeamAndScore
      teamPlayers: (team) ->
        teamPlayers = []
        this.gamesPlayers().forEach((gamesPlayer) ->
          if gamesPlayer.team() == team
            teamPlayers.push(gamesPlayer)
        )
        teamPlayers
    },
    classMethods: {
      inactiveTimeFromNow: (nowMoment) ->
        nowMoment.subtract(10, 'minute')
    }
  }
)
