<template>
<section id='all-games' class='full-height'>
  <div class='row collapse'>
    <div class='medium-6 medium-centered columns'>
      <div v-for='(game, id) in games'>
        {{ game.created_at() }}
        <!-- <span v-for='(player, index) in game.players'>
          {{ player.name }} {{ index != game.players.length - 1 ? '-' : '' }}
        </span> -->
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

    // set `data` values whenever a Game is created
    this.createGameCallback = LiveRecord.Model.all.Game.addCallback('before:create', function() {
      self.$set(self.games, this.id(), this)
    })

    // load all current Games
    LiveRecord.helpers.loadRecords({
      url: Routes.games_path,
      modelName: 'Game'
    })

    // subscribe and auto-fetch new Games
    this.gamesSubscription = LiveRecord.Model.all.Game.subscribe()
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
