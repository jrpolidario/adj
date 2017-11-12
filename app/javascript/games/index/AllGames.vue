<template>
  <div id='all-games' class='full-height'>
    <ShowGame v-for='(game, id) in games' :game='game'/>
  </div>
</template>

<script>
  import ShowGame from './all_games/Show'
  import moment from 'moment'

  export default {
    components: { ShowGame },
    data () {
      return {
        games: LiveRecord.Model.all.Game.all
      }
    },
    created () {
      let self = this

      // load all Game records, and subscribe and auto-fetch new/updated Games
      this.gamesSubscription = LiveRecord.Model.all.Game.autoload({
        reload: true,
        where: {
          updated_at_gt: moment().subtract(1, 'minutes'),
          is_finished_eq: false
        }
      })

      // set `games` values whenever a Game is created
      this.createGameCallback = LiveRecord.Model.all.Game.addCallback('before:create', function() {
        self.$set(self.games, this.id(), this)
      })

      // delete `games` values whenever a Game is removed
      this.destroyGameCallback = LiveRecord.Model.all.Game.addCallback('before:destroy', function() {
        self.$delete(self.games, this.id())
      })

      // check if games are still ongoing every 10000ms, and remove it if not anymore
      window.setInterval(() => {
        Object.keys(self.games).forEach((key, index) => {
          let game = self.games[key]

          // if game has already finished or that there is no longer any activity in the last minute
          if (
            game.is_finished() ||
            moment(game.updated_at()) <= moment().subtract(5, 'seconds')
          ) {
            // we then cleanup and free memory
            game.destroy()
            for (let player of game.players()) {
              player.destroy()
            }
          }
        })
      },1000);
    },
    destroyed () {
      LiveRecord.Model.all.Game.removeCallback('before:create', this.createGameCallback)
      LiveRecord.Model.all.Game.removeCallback('before:destroy', this.destroyGameCallback)
      LiveRecord.Model.all.Game.unsubscribe(this.gamesSubscription)
    }
  }
</script>

<style lang='scss' scoped>
  @import 'app/assets/stylesheets/imports/variables';

  #all-games {
    background-color: $page-base-background-color;
  }
</style>
