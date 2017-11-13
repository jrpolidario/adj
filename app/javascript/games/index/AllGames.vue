<template>
  <div id='all-games' class='full-height'>
    <ShowGame v-for='(game, id) in games' :game='game'/>
  </div>
</template>

<script>
  import { mapState, mapGetters } from 'vuex'
  import ShowGame from './all_games/Show'
  import moment from 'moment'

  export default {
    components: { ShowGame },
    computed: Object.assign(
      {},
      mapState({
        games: (state) => { return state.records.Game }
      }),
      mapGetters(['currentPlayer'])
    ),
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

      // check if games are still ongoing every 5000ms, and remove it if not anymore
      window.setInterval(() => {
        Object.keys(self.games).forEach((key, index) => {
          let game = self.games[key]

          // if game has already finished or that there is no longer any activity in the last minute
          if (
            game.is_finished() ||
            moment(game.updated_at()) <= moment().subtract(1, 'minute')
          ) {
            // we then cleanup and free memory
            game.destroy()
            for (let player of game.players()) {
              // dont destroy currentPlayer though!
              if (player != self.currentPlayer)
                player.destroy()
            }
          }
        })
      }, 5000);
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
