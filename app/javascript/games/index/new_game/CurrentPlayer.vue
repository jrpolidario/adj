<template>
  <div id='current-player'>
    <ShowCurrentPlayer v-if='currentPlayer'/>
    <NewPlayer v-else/>
  </div>
</template>

<script>
  import { mapGetters } from 'vuex'
  import ShowCurrentPlayer from './current_player/Show'
  import NewPlayer from './current_player/New'

  export default {
    components: { ShowCurrentPlayer, NewPlayer },
    computed: mapGetters([
      'currentPlayer'
    ]),
  }
</script>

<style lang='scss' scoped>
</style>
