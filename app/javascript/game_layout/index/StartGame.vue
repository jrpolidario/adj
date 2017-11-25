<template>
  <div id='start-game' class='full-height'>
    <TeamWinnerSelect v-if='isCurrentTurn && game.currentSelectableCard() && game.currentSelectableCard().is_time_is_up() && game.currentSelectableCard().is_time_is_up()' :game='game'/>
    <CardSelect v-else :game='game'/>
  </div>
</template>

<script>
  import { mapActions, mapGetters } from 'vuex'
  import CardSelect from './start_game/CardSelect'
  import TeamWinnerSelect from './start_game/TeamWinnerSelect'

  export default {
    components: { CardSelect, TeamWinnerSelect },
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
    ),
    mounted() {
      window.qwer = this
    }
  }
</script>

<style lang='scss' scoped>
</style>
