<template>
  <transition
    name='custom-classes-transition'
    enter-active-class='animated fadeIn'
  >
    <div id='join-game' class='full-height'>
      <div v-if='preloaded'>
        <h2>Join Game</h2>
        <JoinGameForm
          :gamesPlayer='gamesPlayer'
          :formAction='gamesPlayersPath'
          :formMethod='"post"'
          :onSubmitSuccessCallback='onSubmitSuccessCallback.bind(this)'
        />
      </div>
      <Loader v-else/>
    </div>
  </transition>
</template>

<script>
  import { mapGetters, mapActions } from 'vuex'
  import JoinGameForm from './join_game/Form'
  import Loader from 'shared/Loader'

  export default {
    components: { JoinGameForm, Loader },
    data() {
      return {
        preloaded: false,
        afterPreload() {
          this.authorize()
          this.$forceUpdate()
        },
        game: this.$store.getters.getRecord('Game', this.$route.params.game_id),
        gamesPlayer: new LiveRecord.Model.all.GamesPlayer({game_id: this.$route.params.game_id}),
        subscriptionsToBeDestroyed: [],
        callbacksToBeDestroyed: [],
        onSubmitSuccessCallback(data, status, xhr) {
          const attributes = data
          let createdGamesPlayer = LiveRecord.Model.all.GamesPlayer.all[attributes.id]

          if (!createdGamesPlayer) {
            createdGamesPlayer = new LiveRecord.Model.all.GamesPlayer(attributes)
            createdGamesPlayer.create()
          }

          this.$store.commit('setState', { currentGame: createdGamesPlayer.game() })
          this.$store.commit('setState', { currentGamesPlayer: createdGamesPlayer })

          // then redirect to game page
          this.$router.push({ name: 'gamePath', params: { id: createdGamesPlayer.game().id() } })
        }
      }
    },
    computed: $.extend(
      {
        gamesPlayersPath() { return Routes.game_games_players_path({game_id: this.$route.params.game_id}) }
      },
      mapGetters(['getState'])
    ),
    methods: $.extend(
      {
        checkIfHasJoined() {
          const self = this
          const joinedGamesPlayerSubscription = LiveRecord.Model.all.GamesPlayer.autoload({
            reload: true,
            where: {
              game_id_eq: this.$route.params.game_id,
              player_id_eq: this.getState('currentPlayer').id()
            },
            callbacks: {
              'after:reload': (recordIds) => {
                self.$set(self, 'preloaded', true)
              }
            }
          })
          this.subscriptionsToBeDestroyed.push([LiveRecord.Model.all.GamesPlayer, joinedGamesPlayerSubscription])

          // if already joined the game, set this as currentGame and redirect to game
          if (this.getState('currentPlayer').hasGame(this.game)) {
            this.$store.commit('setState', { currentGame: this.game })
            this.$router.replace({ name: 'gamePath', params: { id: this.game.id() } })
          }
        },
        authorize() {
          if (!this.getState('currentPlayer'))
            this.$router.replace({ name: 'forbiddenPath' })

          if (this.game.is_started()) {
            this.$router.replace({ name: 'rootPath' })
            flash('Can no longer join as Game has already started.', 'error')
          }
        }
      },
      mapActions(['preloadLiveRecords', 'cleanup'])
    ),
    mounted() {
      this.$store.dispatch('scrollToComponent', this.$el)
      this.checkIfHasJoined()
      this.authorize()
    },
    updated() {
      this.authorize()
    },
    destroyed() {
      this.cleanup({ vue: this })
    }
  }
</script>

<style lang='scss' scoped>
  @import 'app/assets/stylesheets/imports/variables';

  #join-game {
    background-color: $page-base-background-color;
  }
</style>
