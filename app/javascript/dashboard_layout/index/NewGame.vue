<template>
  <div id='new-game' class='full-height'>
    <h2>New Game</h2>
    <GameForm
      :game='game'
      :formAction='gamesPath'
      :formMethod='"post"'
      :onSubmitSuccessCallback='onSubmitSuccessCallback.bind(this)'
    />
  </div>
</template>

<script>
  import { mapGetters } from 'vuex'
  import GameForm from './new_game/Form'

  export default {
    components: { GameForm },
    data() {
      return {
        game: new LiveRecord.Model.all.Game(),
        onSubmitSuccessCallback(data, status, xhr) {
          const attributes = data
          const createdGame = new LiveRecord.Model.all.Game(attributes)
          createdGame.create()

          this.$store.commit('setState', { currentGame: createdGame })

          // then redirect to game page
          this.$router.push({ name: 'gamePath', params: { id: createdGame.id() } })
        }
      }
    },
    computed: $.extend(
      {
        gamesPath: () => Routes.games_path()
      },
      mapGetters(['getState'])
    ),
    methods: {
      authorize() {
        if (!this.getState('currentPlayer'))
          this.$router.replace({ name: 'forbiddenPath' })
      },
    },
    created() {
      this.authorize()
    }
  }
</script>

<style lang='scss' scoped>
  @import 'app/assets/stylesheets/imports/variables';

  #new-game {
    background-color: $page-base-background-color;
  }
</style>
