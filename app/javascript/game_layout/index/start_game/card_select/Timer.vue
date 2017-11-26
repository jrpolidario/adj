<template>
  <div id='timer-container'>
    <div id='timer'>
      <div v-bind:style='{ width: barWidth, "background-color": barColor }' class='bar'></div>
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
    },
    computed: {
      barColor() {
        // ref: https://stackoverflow.com/questions/7128675/from-green-to-red-color-depend-on-percentage
        const value = this.game.currentSelectableCard().percentageTimeLeft() / 100.0
        const hue = (value * 120).toString(10)
        return ['hsl(', hue, ',50%,70%)'].join('')
      },
      barWidth() {
        return this.game.currentSelectableCard().percentageTimeLeft() + '%'
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
      border: 1px solid lighten(#aaa, 25);
      border-radius: 0.2em;
      background-color: lighten(#aaa, 25);
      overflow: hidden;

      .bar {
        height: 100%;
        transition: width 1s;
      }
    }
  }
</style>
