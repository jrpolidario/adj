<template>
  <transition
    name='custom-classes-transition'
    enter-active-class='animated fadeIn'
  >
    <div id='new-game' class='full-height'>
      <h2>New Game</h2>
      <GameForm
        :game='game'
        :formAction='gamesPath'
        :formMethod='"post"'
        :onSubmitSuccessCallback='onSubmitSuccessCallback.bind(this)'
      />
    </div>
  </transition>
</template>

<script>
  import { mapGetters, mapActions } from 'vuex'
  import GameForm from './new_game/Form'

  export default {
    components: { GameForm },
    data() {
      const self = this

      return {
        game: new LiveRecord.Model.all.Game(),
        subscriptionsToBeDestroyed: [],
        callbacksToBeDestroyed: [],
        onSubmitSuccessCallback(data, status, xhr) {
          const attributes = data
          const createdGame = new LiveRecord.Model.all.Game(attributes)
          createdGame.create()
          this.$store.commit('setState', { currentGame: createdGame })

          // now we retrieve the GamesPlayer record that has been automatically created after creating the Game
          const subscription = LiveRecord.Model.all.GamesPlayer.autoload({
            reload: true,
            where: {
              player_id_eq: this.getState('currentPlayer').id(),
              game_id_eq: this.getState('currentGame').id()
            },
            callbacks: {
              'after:reload': function(recordIds) {
                self.$store.commit('setState', { currentGamesPlayer: self.getRecord('GamesPlayer', recordIds[0]) })
                // then redirect to game page
                self.$router.push({ name: 'gamePath', params: { id: createdGame.id() } })
              }
            }
          })

          self.subscriptionsToBeDestroyed.push([LiveRecord.Model.all.GamesPlayer, subscription])
        }
      }
    },
    computed: $.extend(
      {
        gamesPath: () => Routes.games_path()
      },
      mapGetters(['getState', 'getRecord'])
    ),
    methods: $.extend(
      {
        authorize() {
          if (!this.getState('currentPlayer'))
            this.$router.replace({ name: 'forbiddenPath' })
        },
      },
      mapActions(['cleanup'])
    ),
    mounted() {
      this.authorize()
    },
    destroyed() {
      this.cleanup({ vue: this })
    }
  }
</script>

<style lang='scss' scoped>
  @import 'app/assets/stylesheets/imports/variables';

  #new-game {
    background-color: $page-base-background-color;
  }
</style>
