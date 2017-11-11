<template>
  <form
    v-bind:action='formAction'
    v-bind:method='["patch", "put", "delete"].includes(formMethod) ? "post" : formMethod'
    data-remote='true'
    data-type='json'
    v-on:ajax:success='onSubmitSuccess'
    v-on:ajax:error='onSubmitError'
  >
    <input v-if='["patch", "put", "delete"].includes(formMethod)' name='_method' type='hidden' v-bind:value='formMethod'/>
    <input
      type='text'
      name='player[name]'
      placeholder='Enter your player name :)'
      v-model='player.attributes.name'
    ></input>
  </form>
</template>

<script>
  export default {
    props: {
      player: {
        type: Object,
        required: true
      },
      formMethod: {
        type: String,
        default: 'post'
      },
      formAction: {
        type: String,
        required: true
      },
      onSubmitSuccessCallback: {
        type: Function
      }
    },
    methods: {
      onSubmitSuccess(event) {
        const data = event.detail[0]
        const status = event.detail[1]
        const xhr = event.detail[2]

        const $form = $(event.currentTarget)
        const $attributeInput = $form.find(':input.error')

        if ($attributeInput.length > 0) {
          $attributeInput.removeClass('error')
          $attributeInput.foundation('_destroy')
        }

        this.$set(this.player, 'name', '')

        this.onSubmitSuccessCallback(data, status, xhr)
      },
      onSubmitError(event) {
        const data = event.detail[0]
        const status = event.detail[1]
        const xhr = event.detail[2]

        const errors = data
        const $form = $(event.currentTarget)

        for (let attribute in errors) {
          let $attributeInput = $form.find(':input').filter('[name="player[' + attribute + ']"]')

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
  form {
    .error {
      border-bottom: 4px solid red;
    }
  }
</style>
