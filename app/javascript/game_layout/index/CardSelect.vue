<template>
  <div id='card-select' class='full-height'>
    <div v-if='isCurrentTurn' id='info'>
      Your turn! :)
    </div>
    <Card
      v-for='position in [1, 2, 3, 4]'
      :game='game'
      :position='position'
    />
  </div>
</template>

<script>
  import { mapActions, mapGetters } from 'vuex'
  import Card from './card_select/Card'

  export default {
    components: { Card },
    props: {
      game: {
        type: Object,
        required: true
      }
    },
    computed: $.extend(
      {
        isCurrentTurn() {
        return this.game.attributes.current_turn_games_player_id == this.getState('currentGamesPlayer').id()
      }
      },
      mapGetters(['getRecord', 'getState'])
    )
  }
</script>

<style lang='scss' scoped>
  #info {
    position: absolute;
    top: -1.5rem;
    left: 0.2rem;
    color: #aaa;
  }
</style>
