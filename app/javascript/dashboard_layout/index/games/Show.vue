<template>
  <router-link tag='tr' v-on:click.native='onGameClick' :to='gameClickPath()' class='show-game'>
    <td class='game-timestamp'>{{ gameTimestamp }}</td>
    <td class='game-players absorbing-column'>
      <i v-if='getState("currentPlayer").hasGame(game)' class='fa fa-gamepad' aria-hidden='true'></i>
      <span v-for='(gamesPlayer, index) in game.gamesPlayers()'>
        {{ gamesPlayer.player().attributes.name }}
        <span v-if='index != game.gamesPlayers().length - 1' class='playerNameDivider'>+</span>
      </span>
    </td>
  </router-link>
</template>

<script>
  import { mapGetters } from 'vuex'
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
        gameTimestamp: moment(this.game.created_at()).fromNow()
      }
    },
    computed: $.extend(
      {
        onGameClick() {
          if (!this.getState('currentPlayer'))
            $('#new-player-name').focus()
        }
      },
      mapGetters(['getRecord', 'getState'])
    ),
    watch: {
      // reload if prop changed
    	game: function(newVal, oldVal) {
        this.loadRecordsAndSubscribe()
      }
    },
    methods: {
      gameClickPath() {
        const currentPlayer = this.getState('currentPlayer')
        let path

        if (!currentPlayer)
          path = '#'
        else if (currentPlayer && currentPlayer.hasGame(this.game))
          path = { name: 'gamePath', params: { id: this.game.id() } }
        else
          path = { name: 'joinGamePath', params: { game_id: this.game.id() } }

        return path
      },
      cleanup() {
        const self = this

        for (let subscriptionToBeDestroyed of this.subscriptionsToBeDestroyed) {
          const model = subscriptionToBeDestroyed[0]
          const subscription = subscriptionToBeDestroyed[1]
          model.unsubscribe(subscription)
        }
        this.subscriptionsToBeDestroyed = []

        for (let callbackToBeDestroyed of this.callbacksToBeDestroyed) {
          const record = callbackToBeDestroyed[0]
          const callback = callbackToBeDestroyed[1]
          record.removeCallback('after:destroy', callback)
        }
        this.callbacksToBeDestroyed = []
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
                player.create({reload: true})
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
              self.$forceUpdate()
            }
          }
        })
        this.subscriptionsToBeDestroyed.push([LiveRecord.Model.all.GamesPlayer, gamesPlayersSubscription])
      }
    },
    created() {
      this.loadRecordsAndSubscribe()
    },
    destroyed() {
      this.cleanup()
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
      border-radius: 50%;
    }

    &:hover {
      background: rgba(white,0.1);
    }

    td.game-timestamp {
      font-size: 0.8em;
      color: #ddd;
      vertical-align: middle;
      padding: 0.5rem;
    }

    td.game-players {
      vertical-align: middle;

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
