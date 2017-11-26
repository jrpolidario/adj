<template>
  <div id='start-game' class='full-height'>
    <transition
      name='custom-classes-transition'
      enter-active-class='animated fadeIn'
    >
      <EndGame v-if='game.is_finished()' :game='game'/>
      <TeamWinnerSelect v-else-if='isCurrentTurn && game.currentSelectableCard() && game.currentSelectableCard().is_time_is_up() && game.currentSelectableCard().is_time_is_up()' :game='game'/>
      <CardSelect v-else :game='game'/>
    </transition>
  </div>
</template>

<script>
  import { mapActions, mapGetters } from 'vuex'
  import EndGame from './start_game/EndGame'
  import TeamWinnerSelect from './start_game/TeamWinnerSelect'
  import CardSelect from './start_game/CardSelect'

  export default {
    components: { EndGame, CardSelect, TeamWinnerSelect },
    props: {
      game: {
        type: Object,
        required: true
      }
    },
    computed: Object.assign(
      {
        isCurrentTurn() {
          return this.game.attributes.current_turn_games_player_id == this.getState('currentGamesPlayer').id()
        }
      },
      mapGetters(['getState'])
    )
  }
</script>

<style lang='scss' scoped>
</style>
