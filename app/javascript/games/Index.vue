<template>
<section id='all-games' class='row collapse full-height full-width'>
  <div class='large-3 medium-4 columns full-height'>
    <NewGame/>
  </div>
  <div class='large-6 medium-4 columns full-height'>
    <div class='full-height'>
      <ShowGame v-for='(game, id) in games' :game='game'/>
    </div>
  </div>
  <div class='large-3 medium-4 columns full-height'>
    <AllComments/>
  </div>
</section>
</template>

<script>
import NewGame from './index/NewGame'
import ShowGame from './index/ShowGame'
import AllComments from './index/AllComments'

export default {
	components: { NewGame, ShowGame, AllComments },
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

    // set `games` values whenever a Game is created
    this.createGameCallback = LiveRecord.Model.all.Game.addCallback('before:create', function() {
      self.$set(self.games, this.id(), this)
    })

    // delete `games` values whenever a Game is removed
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

  // >>> means it affects children components
  > div.columns >>> > * {
    padding: 2rem;
  }
}
</style>
