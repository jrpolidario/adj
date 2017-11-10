<template>
  <div id='new-player'>
    <form v-if='isEditingName'>
    </form>
    <h2 v-else v-on:click='nameOnClick'>{{ currentPlayer.attributes.name }}</h2>
  </div>
</template>

<script>
  import { mapGetters } from 'vuex'
  // import { currentPlayer } from 'globals.js'

  export default {
    data() {
      return {
        isEditingName: false
      }
    },
    computed: mapGetters([
      'currentPlayer'
    ]),
    methods: {
      nameOnClick: {

      }
    }
  }
</script>

<style lang='scss' scoped>
  @import './shared/placeholders';

  #new-player {
    @extend %current-player-container;
  }
</style>
