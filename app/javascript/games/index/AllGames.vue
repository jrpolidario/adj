<template>
  <div id='all-games' class='full-height'>
    <ShowGame v-for='(game, id) in games' :game='game'/>
  </div>
</template>

<script>
  import ShowGame from './all_games/Show'

  export default {
    components: { ShowGame },
    data () {
      return {
        games: LiveRecord.Model.all.Game.all
      }
    },
    created () {
      let self = this

      window.vw = self

      // load all Game records, and subscribe and auto-fetch new Games
      this.gamesSubscription = LiveRecord.Model.all.Game.subscribe({reload: true})

      // set `games` values whenever a Game is created
      this.createGameCallback = LiveRecord.Model.all.Game.addCallback('before:create', function() {
        self.$set(self.games, this.id(), this)
      })

      // delete `games` values whenever a Game is removed
      this.destroyGameCallback = LiveRecord.Model.all.Game.addCallback('before:destroy', function() {
        self.$delete(self.games, this.id())
      })
    },
    destroyed () {
      LiveRecord.Model.all.Game.removeCallback('before:create', this.createGameCallback)
      LiveRecord.Model.all.Game.removeCallback('before:destroy', this.destroyGameCallback)
      LiveRecord.Model.all.Game.unsubscribe(this.gamesSubscription)
    }
  }
</script>

<style lang='scss' scoped>
  @import 'app/javascript/packs/games';

  #all-games {
    background-color: $page-base-background-color;
  }
</style>
