<template>
  <div class='show-game'>
    <span v-for='(gamesPlayer, index) in game.gamesPlayers()'>
      {{ gamesPlayer.player().attributes.name }} {{ index != game.gamesPlayers().length - 1 ? '-' : '' }}
    </span>
  </div>
</template>

<script>
  export default {
    props: {
      game: {
        type: Object,
        required: true
      }
    },
    data() {
      return {
        destroyGamesPlayersCallbacks: [],
      }
    },
    created() {
      const self = this

      this.gamesPlayersSubscription = LiveRecord.Model.all.GamesPlayer.subscribe({
        reload: true,
        where: { game_id_eq: this.game.id() },
        callbacks: {
          'after:create': function(data) {
            self.$forceUpdate()

            const createdGamesPlayer = LiveRecord.Model.all.GamesPlayer.all[data.attributes.id]
            const destroyGamesPlayerCallback = createdGamesPlayer.addCallback('after:destroy', function() {
              self.$forceUpdate()
            })

            self.destroyGamesPlayersCallbacks.push([createdGamesPlayer, destroyGamesPlayerCallback])
          }
        }
      })
    },
    destroyed() {
      LiveRecord.Model.all.GamesPlayer.unsubscribe(this.gamesPlayersSubscription)

      for (let destroyGamesPlayersCallback of this.destroyGamesPlayersCallbacks) {
        const gamePlayer = destroyGamesPlayersCallback[0]
        const callback = destroyGamesPlayersCallback[1]
        gamePlayer.removeCallback('after:destroy', callback)
      }
    }
  }
</script>

<style lang='scss' scoped>
  .show-game {
    text-shadow: 0 1px 1px rgba(0,0,0,0.2)
  }
</style>
