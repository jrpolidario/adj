<template>
<section id='all-games' class='full-height'>
  <div class='row collapse'>
    <div class='medium-6 medium-centered columns'>
      <div v-for='(game, id) in games'>
        <span v-for='(player, index) in game.players()'>
          {{ player.name() }} {{ index != game.players().length - 1 ? '-' : '' }}
        </span>
      </div>
    </div>
  </div>
</section>
</template>

<script>
// import NewGame from './New'
// import NewPlayer from './players/New'

export default {
	// components: { NewGame, NewPlayer },
  data () {
    return {
      games: LiveRecord.Model.all.Game.all
    }
  },
  created () {
    let self = this

    window.vw = self

    // subscribe and auto-fetch new Games
    this.gamesSubscription = LiveRecord.Model.all.Game.subscribe({
      callbacks: {
        'on:connect': function() {
          // temp hack to immediately force LiveRecord `syncRecords` for all records
          self.gamesSubscription.liveRecord._staleSince = (new Date(1900)).toISOString()
          self.gamesSubscription.syncRecords()
        }
      }
    })

    // set `data` values whenever a Game is created
    this.createGameCallback = LiveRecord.Model.all.Game.addCallback('before:create', function() {
      self.$set(self.games, this.id(), this)

      this.playersSubscriptions || (this.playersSubscriptions = [])
      const playerSubscription = LiveRecord.Model.all.Player.subscribe({
        where: { game_id_eq: this.id() },
        callbacks: {
          'on:connect': function() {
            // temp hack to immediately force LiveRecord `syncRecords` for all records
            playerSubscription.liveRecord._staleSince = (new Date(1900)).toISOString()
            playerSubscription.syncRecords()
          }
        }
      })
      this.playersSubscriptions.push(playerSubscription)
    })

    // set `data` values whenever a Player is created
    this.createPlayerCallback = LiveRecord.Model.all.Player.addCallback('before:create', function() {
      // self.$set(self.games, this.game().id(), this.game())
      self.$forceUpdate()
    })
  },
  destroyed () {
    LiveRecord.Model.all.Game.removeCallback(this.createGameCallback)
    LiveRecord.Model.all.Game.unsubscribe(this.gamesSubscription)
  }
  // data () {
  //   return {
  //     games: [
  //       {
  //         players: [
  //           {
  //             name: 'Jules'
  //           },
  //           {
  //             name: 'Jonas'
  //           }
  //         ]
  //       }
  //     ]
  //   }
  // }
}
</script>

<style lang='scss' scoped>
#all-games {
  background-color: #7CBB91;
  color: white;
}
</style>
