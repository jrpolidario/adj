<template>
  <div id='timer-container'>
    <div id='timer'>
      <div v-bind:style='{ width: game.currentSelectableCard().percentageTimeLeft() }' class='bar'></div>
    </div>
  </div>
</template>

<script>
  import { mapActions, mapGetters } from 'vuex'

  export default {
    props: {
      game: {
        type: Object,
        required: true
      }
    },
    data() {
      return {
        startingSecondsLeft: null
      }
    }
  }
</script>

<style lang='scss' scoped>
  @import 'app/assets/stylesheets/imports/variables';

  #timer-container {
    position: absolute;
    top: 50%;
    width: 100%;
    padding: 0.5em;
    transform: translateY(-50%);

    #timer {
      width: 100%;
      height: 0.4em;
      border: 1px solid lighten($page-base-background-color, 25);
      border-radius: 0.2em;
      background-color: lighten($page-base-background-color, 35);
      overflow: hidden;

      .bar {
        height: 100%;
        background-color: $page-base-background-color;
        transition: width 1s;
      }
    }
  }
</style>
