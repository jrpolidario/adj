<template>
<section id='all-games' class='full-height'>
  <div class='row collapse'>
    <div class='medium-6 medium-centered columns'>
      <ShowGame v-for='(game, id) in games' :game='game'/>
    </div>
  </div>
</section>
</template>

<script>
import ShowGame from './index/ShowGame'

export default {
	components: { ShowGame },
  data () {
    return {
      games: LiveRecord.Model.all.Game.all
    }
  },
  created () {
    let self = this

    window.vw = self

    // load all Game records, and subscribe and auto-fetch new Games
    this.gamesSubscription = LiveRecord.Model.all.Game.subscribe({reload: true})

    // set `data` values whenever a Game is created
    this.createGameCallback = LiveRecord.Model.all.Game.addCallback('before:create', function() {
      self.$set(self.games, this.id(), this)
    })

    // delete `data` values whenever a Game is removed
    this.destroyGameCallback = LiveRecord.Model.all.Game.addCallback('before:destroy', function() {
      self.$delete(self.games, this.id())
    })
  },
  destroyed () {
    LiveRecord.Model.all.Game.removeCallback('before:create', this.createGameCallback)
    LiveRecord.Model.all.Game.removeCallback('before:destroy', this.destroyGameCallback)
    LiveRecord.Model.all.Game.unsubscribe(this.gamesSubscription)
  }
}
</script>

<style lang='scss' scoped>
#all-games {
  background-color: #7CBB91;
  color: white;
}
</style>
