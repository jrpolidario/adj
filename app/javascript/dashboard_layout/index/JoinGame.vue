<template>
  <div id='join-game' class='full-height'>
    <h2>Join Game</h2>
    <JoinGameForm
      :gamesPlayer='gamesPlayer'
      :formAction='gamesPlayersPath'
      :formMethod='"post"'
      :onSubmitSuccessCallback='onSubmitSuccessCallback.bind(this)'
    />
  </div>
</template>

<script>
  import { mapGetters } from 'vuex'
  import JoinGameForm from './join_game/Form'

  export default {
    components: { JoinGameForm },
    data() {
      return {
        gamesPlayer: new LiveRecord.Model.all.GamesPlayer({game_id: this.$route.params.game_id}),
        subscriptionsToBeDestroyed: [],
        onSubmitSuccessCallback(data, status, xhr) {
          const attributes = data
          const createdGamesPlayer = new LiveRecord.Model.all.GamesPlayer(attributes)
          createdGamesPlayer.create({reload: true})

          this.$store.commit('setState', { currentGame: createdGamesPlayer.game() })

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
    methods: {
      authorize() {
        if (!this.getState('currentPlayer'))
          this.$router.replace({ name: 'forbiddenPath' })

        const joinedGamesPlayerSubscription = LiveRecord.Model.all.GamesPlayer.all.autoload({
          reload: true,
          where: {
            game_id_eq: this.$route.params.game_id,
            player_id_eq: this.getState('currentPlayer')
          },
          callbacks: {
            'after:reload': (recordIds) => {
              debugger
            }
          }
        })
        this.subscriptionsToBeDestroyed.push([LiveRecord.Model.all.GamesPlayer, joinedGamesPlayerSubscription])

        // // if already joined the game, redirect to game
        // if (this.getState('currentGame') &&
        //   this.getState('currentGame').id() == this.$route.params.game_id )
        //   this.$router.replace({ name: 'gamePath', params: { id: this.$route.params.game_id } })
      },
    },
    created() {
      this.authorize()
    },
    destroy() {
      for (let subscriptionToBeDestroyed of this.subscriptionsToBeDestroyed) {
        const model = subscriptionToBeDestroyed[0]
        const subscription = subscriptionToBeDestroyed[1]
        model.unsubscribe(subscription)
      }
    }
  }
</script>

<style lang='scss' scoped>
  @import 'app/assets/stylesheets/imports/variables';

  #join-game {
    background-color: $page-base-background-color;
  }
</style>
