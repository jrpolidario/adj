<template>
  <div id='current-game'>
    <h2 v-if='getState("currentGame")'>{{ getState("currentGame").id() }}</h2>
  </div>
</template>

<script>
  import { mapGetters } from 'vuex'
  import ShowCurrentPlayer from './current_player/Show'

  export default {
    computed: mapGetters([
      'getState'
    ]),
  }
</script>

<style lang='scss' scoped>
</style>
