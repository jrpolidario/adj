<template>
  <router-link v-if='preloaded' tag='tr' v-on:click.native='onGameClick' :to='gameClickPath()' class='show-game'>
    <td class='game-timestamp'>{{ gameTimestamp }}</td>
    <td class='game-players absorbing-column'>
      <i v-if='getState("currentGame") == game' class='fa fa-gamepad' aria-hidden='true'></i>
      <span v-for='(gamesPlayer, index) in game.gamesPlayers()'>
        {{ gamesPlayer.player().attributes.name }}
        <span v-if='index != game.gamesPlayers().length - 1' class='playerNameDivider'>+</span>
      </span>
    </td>
  </router-link>
  <tr v-else></tr>
</template>

<script>
  import { mapGetters, mapActions } from 'vuex'
  import moment from 'moment'

  export default {
    props: {
      game: {
        type: Object,
        required: true
      }
    },
    data() {
      return {
        callbacksToBeDestroyed: [],
        subscriptionsToBeDestroyed: [],
        preloaded: false,
        afterPreload() {
          this.$forceUpdate()
        },
        gameTimestamp: moment(this.game.created_at()).fromNow(),
        onGameClick() {
          if (!this.getState('currentPlayer'))
            $('#new-player-name').focus()
        },
      }
    },
    computed: mapGetters(['getRecord', 'getState']),
    watch: {
      // reload if prop changed
    	game: function(newVal, oldVal) {
        this.loadRecordsAndSubscribe()
      }
    },
    methods: $.extend(
      {
        gameClickPath() {
          const currentPlayer = this.getState('currentPlayer')
          let path

          if (!currentPlayer)
            path = '#'
          else if (this.getState('currentPlayer').hasGame(this.game) && this.getState('currentGame') == this.game)
            path = { name: 'gamePath', params: { id: this.game.id() } }
          else
            path = { name: 'joinGamePath', params: { game_id: this.game.id() }, hash: "#middle-pane" }

          return path
        },
        loadRecordsAndSubscribe() {
          const self = this

          const gamesPlayersSubscription = LiveRecord.Model.all.GamesPlayer.autoload({
            reload: true,
            where: { game_id_eq: this.game.id() },
            callbacks: {
              'after:createOrUpdate': function(record) {
                const createdGamesPlayer = LiveRecord.Model.all.GamesPlayer.all[record.attributes.id]
                const callbackToBeDestroyed = createdGamesPlayer.addCallback('after:destroy', function() {
                  self.$forceUpdate()
                })
                self.callbacksToBeDestroyed.push([createdGamesPlayer, callbackToBeDestroyed])

                let player = LiveRecord.Model.all.Player.all[createdGamesPlayer.player_id()]

                // if the player associated to the gamesPlayer is not yet in the store, we also retrieve it
                if (!player) {
                  player = new LiveRecord.Model.all.Player({id: createdGamesPlayer.player_id()})
                  player.create()
                }

                const playerUpdateCallback = player.addCallback('after:update', function() {
                  self.$store.commit('setRecord', { Player: player })
                  self.$forceUpdate()
                })

                const playerDestroyCallback = player.addCallback('after:destroy', function() {
                  self.$store.commit('unsetRecord', { Player: player })
                  self.$forceUpdate()
                })

                self.callbacksToBeDestroyed.push([player, playerUpdateCallback])
                self.callbacksToBeDestroyed.push([player, playerDestroyCallback])

                self.$forceUpdate()
              },
              'after:reload': function(recordIds) {
                self.$set(self, 'preloaded', true)
              }
            }
          })
          self.subscriptionsToBeDestroyed.push([LiveRecord.Model.all.GamesPlayer, gamesPlayersSubscription])
        }
      },
      mapActions(['cleanup'])
    ),
    mounted() {
      this.loadRecordsAndSubscribe()
    },
    destroyed() {
      this.cleanup({ vue: this })
    }
  }
</script>

<style lang='scss' scoped>
  tr.show-game {
    text-shadow: 0 1px 1px rgba(0,0,0,0.2);
    border-top: 1px solid rgba(white, 0.1);
    white-space: nowrap;
    cursor: pointer;

    .fa {
      margin-right: 0.5em;
      color: #ffbaba;
      padding: 0.2em;
    }

    &:hover {
      background: rgba(white,0.1);
    }

    td.game-timestamp {
      font-size: 0.8em;
      color: #ddd;
      vertical-align: middle;
      padding: 0.6em;
    }

    td.game-players {
      vertical-align: middle;
      padding: 0.4em;

      .playerNameDivider {
        font-size: 0.8em;
        vertical-align: middle;
        color: #ccc;
      }
    }

    td.absorbing-column {
      width: 100%;
    }

    td {
      padding-right: 1rem !important;
    }
  }
</style>
