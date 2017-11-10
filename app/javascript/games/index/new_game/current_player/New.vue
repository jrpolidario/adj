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
      },
      onSubmitError(event) {
        const data = event.detail[0]
        const status = event.detail[1]
        const xhr = event.detail[2]

        const errors = data
        const $form = $(event.currentTarget)

        for (let attribute in errors) {
          let $attributeInput = $form.find(':input, [name="' + attribute + '"]')

          for (let errorMessage of errors[attribute]) {
            // attribute errorMessage
            // TODO: handle form errors
            var elem = new Foundation.Tooltip($attributeInput, {'tip-text': errorMessage});
          }
        }
      }
    }
  }
</script>

<style lang='scss' scoped>
  #new-player {
    margin-top: 4rem;

    h2 {
      color: white;
      font-size: 1.5em;
    }
  }
</style>
