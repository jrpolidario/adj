<template>
  <div>
    <span v-for='(player, index) in game.players()'>
      {{ player.name() }} {{ index != game.players().length - 1 ? '-' : '' }}
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
      destroyPlayerPlayersAndCallbacks: [],
    }
  },
  created() {
    const self = this

    this.playersSubscription = LiveRecord.Model.all.Player.subscribe({
      reload: true,
      where: { game_id_eq: this.game.id() },
      callbacks: {
        'after:create': function(data) {
          self.$forceUpdate()

          const createdPlayer = LiveRecord.Model.all.Player.all[data.attributes.id]
          const destroyPlayerCallback = createdPlayer.addCallback('after:destroy', function() {
            self.$forceUpdate()
          })

          self.destroyPlayerPlayersAndCallbacks.push([createdPlayer, destroyPlayerCallback])
        }
      }
    })
  },
  destroyed() {
    LiveRecord.Model.all.Player.unsubscribe(this.playersSubscription)

    for (let destroyPlayerPlayerAndCallback of this.destroyPlayerPlayersAndCallbacks) {
      const createdPlayer = destroyPlayerPlayerAndCallback[0]
      const destroyPlayerCallback = destroyPlayerPlayerAndCallback[1]
      createdPlayer.removeCallback('after:destroy', destroyPlayerCallback)
    }
  }
}
</script>
