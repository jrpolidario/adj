<template>
  <transition
    name='custom-classes-transition'
    enter-active-class='animated fadeIn'
  >
    <section id='games' class='full-height loader-anchor'>
      <h2>Lobby</h2>
      <div class='players-count'><span class='online-icon'></span> <span class='online-count'>{{ playersCountText }}</span></div>
      <router-link v-if='getState("currentPlayer")' :to='{ name: "newGamePath", hash: "#middle-pane" }' class='button'>
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
        playersCount: null,
        onlineCounterSubscription: null
      }
    },
    computed: Object.assign(
      {
        playersCountText() {
          return (this.playersCount == null ? '-' : this.playersCount) + ' ' +
            (this.playersCount == 1 ? 'player' : 'players') + ' online'
        }
      },
      mapState({
        games: (state) => { return state.records.Game }
      }),
      mapGetters(['getState'])
    ),
    methods: mapActions(['preloadLiveRecords', 'cleanup']),
    mounted () {
      const self = this

      // subscribe to the changes to the number of online players
      this.onlineCounterSubscription = App.cable.subscriptions.create('OnlineCounterChannel', {
        connected() {
          this.perform('broadcast_count')
        },
        received(data) {
          self.$set(self, 'playersCount', data.count)
        }
      })

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
      this.onlineCounterSubscription.unsubscribe()
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

    .players-count {
      .online-icon {
        border-radius: 50%;
        width: 0.5em;
        height: 0.5em;
        display: inline-block;
        background: mix(green, lighten($page-base-background-color, 30), 66%);
        border: 1px solid mix(green, darken($page-base-background-color, 10), 66%);
        vertical-align: middle;
        margin-right: 0.2em;
      }
      .online-count {
        display: inline-block;
        vertical-align: middle;
        font-size: 0.8em;
        color: lighten($page-base-background-color, 20);
      }
      margin-bottom: 0.8em;
    }
  }
</style>
