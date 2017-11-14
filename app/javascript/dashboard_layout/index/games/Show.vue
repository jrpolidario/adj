<template>
  <router-link tag='tr' :to='{ name: "joinGamePath", params: { game_id: game.id() } }' class='show-game'>
    <td class='game-timestamp'>{{ gameTimestamp }}</td>
    <td class='game-players absorbing-column'>
      <span v-for='(gamesPlayer, index) in game.gamesPlayers()'>
        {{ gamesPlayer.player().attributes.name }}
        {{ index != game.gamesPlayers().length - 1 ? '-' : '' }}
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
    computed: mapGetters(['getRecord']),
    created() {
      const self = this

      // if (this.game.id() == 24)
      //   window.yy = self

      const gamesPlayersSubscription = LiveRecord.Model.all.GamesPlayer.autoload({
        reload: true,
        where: { game_id_eq: this.game.id() },
        callbacks: {
          'after:createOrUpdate': function(data) {
            self.$forceUpdate()

            const createdGamesPlayer = LiveRecord.Model.all.GamesPlayer.all[data.attributes.id]
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

            const playerDestroyCallback = player.addCallback('after:update', function() {
              self.$store.commit('setRecord', { Player: player })
              self.$forceUpdate()
            })

            self.callbacksToBeDestroyed.push([player, playerUpdateCallback])
            self.callbacksToBeDestroyed.push([player, playerDestroyCallback])
          }
        }
      })
      this.subscriptionsToBeDestroyed.push([LiveRecord.Model.all.GamesPlayer, gamesPlayersSubscription])
    },
    destroyed() {
      for (let subscriptionToBeDestroyed of this.subscriptionsToBeDestroyed) {
        const model = subscriptionToBeDestroyed[0]
        const subscription = subscriptionToBeDestroyed[1]
        model.unsubscribe(subscription)
      }

      for (let callbackToBeDestroyed of this.callbacksToBeDestroyed) {
        const record = callbackToBeDestroyed[0]
        const callback = callbackToBeDestroyed[1]
        record.removeCallback('after:destroy', callback)
      }
    }
  }
</script>

<style lang='scss' scoped>
  tr.show-game {
    text-shadow: 0 1px 1px rgba(0,0,0,0.2);
    border-top: 1px solid rgba(white, 0.1);
    white-space: nowrap;
    cursor: pointer;

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
    }

    td.absorbing-column {
      width: 100%;
    }

    td {
      padding-right: 1rem !important;
    }
  }
</style>
