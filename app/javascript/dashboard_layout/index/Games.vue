<template>
  <transition
    name='custom-classes-transition'
    enter-active-class='animated fadeIn'
  >
    <section id='games' class='full-height loader-anchor'>
      <h2>Lobby</h2>
      <router-link v-if='getState("currentPlayer")' :to='{ name: "newGamePath" }' class='button'>
        <i class='fa fa-gamepad' aria-hidden='true'></i> New Game
      </router-link>
      <table v-if='preloaded'>
        <ShowGame v-for='(game, id) in games' :game='game'/>
      </table>
      <Loader v-else/>
    </section>
  </transition>
</template>

<script>
  import { mapState, mapGetters, mapActions } from 'vuex'
  import ShowGame from './games/Show'
  import Loader from 'shared/Loader'
  import moment from 'moment'

  export default {
    components: { ShowGame, Loader },
    data() {
      return {
        subscriptionsToBeDestroyed: [],
        callbacksToBeDestroyed: [],
        preloaded: false,
        afterPreload() {
          this.$set(this, 'preloaded', true)
        },
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
    methods: mapActions(['preloadLiveRecords', 'cleanup']),
    mounted () {
      this.$store.dispatch('scrollToComponent', this.$el)
      let self = this

      // load all Game records, and subscribe and auto-fetch new/updated Games
      const gamesSubscription = LiveRecord.Model.all.Game.autoload({
        reload: true,
        where: {
          updated_at_gt: LiveRecord.Model.all.Game.inactiveTimeFromNow(moment()),
          is_finished_eq: false,
          is_started_eq: false
        },
        callbacks: {
          'after:reload': function() {
            self.$set(self, 'preloaded', true)
          }
        }
      })

      this.subscriptionsToBeDestroyed.push([LiveRecord.Model.all.Game, gamesSubscription])

      // check if games are still ongoing every 5000ms, and remove it if not anymore
      window.setInterval(() => {
        Object.keys(self.games).forEach((key, index) => {
          let game = self.games[key]

          // if game has already finished or that there is no longer any activity in the last minute
          if (
            game.is_finished() ||
            moment(game.updated_at()) <= LiveRecord.Model.all.Game.inactiveTimeFromNow(moment())
          ) {
            // we then cleanup and free memory
            game.destroy()
            for (let gamesPlayer of game.gamesPlayers()) {
              gamesPlayer.destroy()
            }
          }
        })
      }, 5000);
    },
    destroyed () {
      this.cleanup({ vue: this })
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
