<template>
  <div id='show-player'>
    <span class='welcome-text'>Welcome!</span>
    <PlayerForm
      v-if='isEditingName'
      :player='getState("currentPlayer")'
      :formAction='editPlayerSubmitPath'
      :formMethod='"put"'
      :onSubmitSuccessCallback='onSubmitSuccessCallback.bind(this)'
    />
    <h2 class='editable' v-else v-on:click='isEditingName = true'>{{ getState('currentPlayer').attributes.name }}</h2>
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
        }
      }
    },
    computed: Object.assign(
      {
        editPlayerSubmitPath() {
          return Routes.player_path(this.getState('currentPlayer').attributes.id)
        }
      },
      mapGetters([
        'getState'
      ])
    )
  }
</script>

<style lang='scss' scoped>
  @import 'app/assets/stylesheets/imports/variables';
  @import './shared/placeholders';

  #show-player {
    @extend %current-player-container;

    .welcome-text {
      padding: 0.5rem;
      font-size: 1.2em;
      font-family: $default-font-header-sans;
    }

    .editable {
      @extend %form-styles;
      cursor: pointer;
    }
  }
</style>
