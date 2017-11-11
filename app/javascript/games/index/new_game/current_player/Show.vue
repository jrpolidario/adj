<template>
  <div id='new-player'>
    <PlayerForm
      v-if='isEditingName'
      :player='currentPlayer'
      :formAction='editPlayerSubmitPath'
      :formMethod='"put"'
      :onSubmitSuccessCallback='onSubmitSuccessCallback.bind(this)'
    />
    <h2 v-else v-on:click='isEditingName = true'>{{ currentPlayer.attributes.name }}</h2>
  </div>
</template>

<script>
  import { mapGetters } from 'vuex'
  import PlayerForm from './shared/Form'

  export default {
    components: { PlayerForm },
    data() {
      return {
        isEditingName: false,
        onSubmitSuccessCallback(data, status, xhr) {
          // wont need to manually update player attributes, because it's LiveRecord already does that for us
          this.isEditingName = false
        }
      }
    },
    computed: Object.assign(
      {
        editPlayerSubmitPath() {
          return Routes.player_path(this.currentPlayer.attributes.id)
        }
      },
      mapGetters([
        'currentPlayer'
      ])
    )
  }
</script>

<style lang='scss' scoped>
  @import './shared/placeholders';

  #new-player {
    @extend %current-player-container;
  }
</style>
