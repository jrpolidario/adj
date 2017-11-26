<template>
  <section id='new-player'>
    <h2>Hey There!</h2>
    <PlayerForm
      :player='newPlayer'
      :formAction='newPlayerSubmitPath'
      :onSubmitSuccessCallback='onSubmitSuccessCallback'
    />
  </section>
</template>

<script>
  import PlayerForm from './shared/Form'

  export default {
    components: { PlayerForm },
    data () {
      return {
        newPlayer: new LiveRecord.Model.all.Player(),
        newPlayerSubmitPath: Routes.players_path(),
        onSubmitSuccessCallback(data, status, xhr) {
          const attributes = data
          const createdPlayer = new LiveRecord.Model.all.Player(attributes)
          createdPlayer.create()

          this.$store.commit('setState', { currentPlayer: createdPlayer })
        }
      }
    }
  }
</script>

<style lang='scss' scoped>
  @import './shared/placeholders';

  #new-player {
    @extend %current-player-container;

    h2 {
      color: white;
      font-size: 1.2em;
    }
  }
</style>
