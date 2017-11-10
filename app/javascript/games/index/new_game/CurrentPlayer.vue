<template>
  <div id='current-player'>
    <ShowCurrentPlayer v-if='currentPlayer'/>
    <NewPlayer v-else/>
  </div>
</template>

<script>
  import ShowCurrentPlayer from './current_player/Show'
  import NewPlayer from './current_player/New'
  import { currentPlayer } from 'globals.js'

  export default {
    components: { ShowCurrentPlayer, NewPlayer },
    beforeCreate() {
      // initialize a sesssion if not yet initialized
      if (!this.$session.exists())
        this.$session.start()
    },
    computed: {
      currentPlayer
    }
  }
</script>

<style lang='scss' scoped>
</style>
