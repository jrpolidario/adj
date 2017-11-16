<template>
  <div id='games' class='full-height'>
    <h2>Ongoing Games</h2>
    <router-link v-if='getState("currentPlayer")' :to='{ name: "newGamePath" }' class='button'>
      <i class='fa fa-gamepad' aria-hidden='true'></i> New Game
    </router-link>
    <table>
      <ShowGame v-for='(game, id) in games' :game='game'/>
    </table>
  </div>
</template>

<script>
  import { mapState, mapGetters } from 'vuex'
  import ShowGame from './games/Show'
  import moment from 'moment'

  export default {
    components: { ShowGame },
    data() {
      return {
        newGamePath: Routes.new_game_path()
      }
    },
    computed: Object.assign(
      {},
      mapState({
        games: (state) => { return state.records.Game }
      }),
      mapGetters(['getState'])
    ),
    created () {
      let self = this

      window.rr = self

      // load all Game records, and subscribe and auto-fetch new/updated Games
      this.gamesSubscription = LiveRecord.Model.all.Game.autoload({
        reload: true,
        // where: {
        //   updated_at_gt: moment().subtract(1, 'minutes'),
        //   is_finished_eq: false
        // }
      })

      // // check if games are still ongoing every 5000ms, and remove it if not anymore
      // window.setInterval(() => {
      //   Object.keys(self.games).forEach((key, index) => {
      //     let game = self.games[key]
      //
      //     // if game has already finished or that there is no longer any activity in the last minute
      //     if (
      //       game.is_finished() ||
      //       moment(game.updated_at()) <= moment().subtract(5, 'seconds')
      //     ) {
      //       // we then cleanup and free memory
      //       game.destroy()
      //       for (let gamesPlayer of game.gamesPlayers()) {
      //         gamesPlayer.destroy()
      //       }
      //     }
      //   })
      // }, 5000);
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

  #games {
    background-color: $page-base-background-color;

    table {
      table-layout: auto;
      border-collapse: collapse;
      display: block;
      overflow: hidden;
    }
  }
</style>
