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
        onSubmitSuccessCallback(data, status, xhr) {
          // const attributes = data
          // const createdGame = new LiveRecord.Model.all.Game(attributes)
          // createdGame.create()
          //
          // this.$store.commit('setState', { currentGame: createdGame })
          //
          // // then redirect to game page
          // this.$router.push({ name: 'gamePath', params: { id: createdGame.id() } })
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
      },
    },
    created() {
      this.authorize()
    }
  }
</script>

<style lang='scss' scoped>
  @import 'app/assets/stylesheets/imports/variables';

  #join-game {
    background-color: $page-base-background-color;
  }
</style>
