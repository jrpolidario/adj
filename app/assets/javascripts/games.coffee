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
          teamAndScoreRight[1] - teamAndScoreLeft[1]
        )
        teamsAndScores
      winners: ->
        winners = []
        highestScore = 0
        for teamAndScore in this.teamsAndScores()
          if teamAndScore[1] >= highestScore
            highestScore = teamAndScore[1]
            winners.push(teamAndScore)
          else
            break
        winners
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
