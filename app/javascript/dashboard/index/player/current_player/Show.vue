<template>
  <div id='show-player'>
    <PlayerForm
      v-if='isEditingName'
      :player='currentPlayer'
      :formAction='editPlayerSubmitPath'
      :formMethod='"put"'
      :onSubmitSuccessCallback='onSubmitSuccessCallback.bind(this)'
      :onFormBlurCallback='onFormBlurCallback.bind(this)'
    />
    <h2 class='editable' v-else v-on:click='isEditingName = true'>{{ currentPlayer.attributes.name }}</h2>
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
          // wont need to manually update player attributes, because LiveRecord already does that for us
          this.isEditingName = false
        },
        onFormBlurCallback() {
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

  #show-player {
    @extend %current-player-container;

    .editable {
      @extend %form-styles;
      cursor: pointer;
    }
  }
</style>
