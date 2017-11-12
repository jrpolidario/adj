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
      ref='name'
      placeholder='Enter name :)'
      v-on:blur='onFormBlurCallback'
      v-on:keyup.esc='onFormBlurCallback'
      v-model='formValues.name'
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
      onFormBlurCallback: {
        type: Function,
        default: () => {}
      },
      onSubmitSuccessCallback: {
        type: Function,
        default: () => {}
      }
    },
    data() {
      return {
        formValues: jQuery.extend({}, this.player.attributes) // clone
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
    },
    mounted() {
      // focus the "name" input field
      this.$refs.name.focus()
    }
  }
</script>

<style lang='scss' scoped>
  @import './placeholders';

  form {
    .error {
      border-bottom: 4px solid red;
    }

    input, input:focus {
      $input-border-size: 1px;
      @extend %form-styles;
      border: $input-border-size solid rgba(255,255,255,0.3);
      background: rgba(255,255,255, 0.1);
      color: white;
      margin: -($input-border-size);
    }
  }
</style>
