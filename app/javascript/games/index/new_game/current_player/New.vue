<template>
  <section id='new-player'>
    <h2>Hey There!</h2>
    <form
      v-bind:action='newPlayerSubmitPath'
      method='post'
      data-remote='true'
      data-type='json'
      v-on:ajax:success='onSubmitSuccess'
      v-on:ajax:error='onSubmitError'
    >
      <input
        type='text'
        name='player[name]'
        placeholder='Enter your player name :)'
        v-model='newPlayer.name'
      ></input>
    </form>
  </section>
</template>

<script>
  export default {
    data () {
      return {
        newPlayer: {
          name: ''
        },
        newPlayerSubmitPath: Routes.players_path()
      }
    },
    methods: {
      onSubmitSuccess(event) {
        const data = event.detail[0]
        const status = event.detail[1]
        const xhr = event.detail[2]

        const attributes = data
        const createdPlayer = new LiveRecord.Model.all.Player(attributes)
        createdPlayer.create()

        this.$store.commit('setCurrentPlayer', createdPlayer)

        const $form = $(event.currentTarget)
        const $attributeInput = $form.find(':input.error')

        if ($attributeInput.length > 0) {
          $attributeInput.removeClass('error')
          $attributeInput.foundation('_destroy')
        }
        
        this.$set(this.newPlayer, 'name', '')
      },
      onSubmitError(event) {
        const data = event.detail[0]
        const status = event.detail[1]
        const xhr = event.detail[2]

        const errors = data
        const $form = $(event.currentTarget)

        for (let attribute in errors) {
          let $attributeInput = $form.find(':input, [name="' + attribute + '"]')

          let errorMessagesString = errors[attribute].join('\n')

          const element = new Foundation.Tooltip($attributeInput, {
            tipText: errorMessagesString,
            position: 'bottom',
            alignment: 'left',
            fadeOutDuration: 200
          });

          $attributeInput.addClass('error')
          $attributeInput.foundation('show')
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
      font-size: 1.5em;
    }
  }

  form {
    .error {
      border-bottom: 4px solid red;
    }
  }
</style>
