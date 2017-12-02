<template>
  <form
    ref='form'
    id='player-form'
    v-bind:action='formAction'
    v-bind:method='["patch", "put", "delete"].includes(formMethod) ? "post" : formMethod'
    data-remote='true'
    data-type='json'
    v-on:ajax:success='onSubmitSuccess'
    v-on:ajax:error='onSubmitError'
  >
    <input v-if='["patch", "put", "delete"].includes(formMethod)' name='_method' type='hidden' v-bind:value='formMethod'/>
    <input type='hidden' name='authenticity_token' v-bind:value='getState("csrfToken")'>
    <input
      id='new-player-name'
      type='text'
      name='player[name]'
      ref='name'
      placeholder='Player name :)'
      v-on:blur='onFormBlur'
      v-on:keyup.esc='onFormBlur'
      v-model='formValues.name'
    ></input>
  </form>
</template>

<script>
  import { mapGetters } from 'vuex'

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
        formValues: $.extend({}, this.player.attributes) // clone
      }
    },
    computed: mapGetters(['getState', 'getRecord']),
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

        this.$set(this.formValues, 'name', '')

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

          if ($attributeInput.length > 0) {
            const element = new Foundation.Tooltip($attributeInput, {
              tipText: errorMessagesString,
              position: 'top',
              alignment: 'left',
              fadeOutDuration: 200
            });

            $attributeInput.addClass('error')
            $attributeInput.foundation('show')
          }
          else
            flash(attribute + ': ' + errorMessagesString, 'error')
        }
      },
      onFormBlur(event) {
        Rails.fire(this.$refs.form, 'submit')
        this.onFormBlurCallback()
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
  @import 'app/javascript/shared/mixins.scss';

  form#player-form {
    .error {
      border-bottom: 2px solid rgba(#E63946, 1);
    }

    input, input:focus {
      $input-border-size: 1px;
      @extend %form-styles;
      border-radius: 0.15rem;
      border: $input-border-size solid rgba(255,255,255,0.3);
      background: rgba(255,255,255, 0.1);
      color: white;
      margin: -($input-border-size);
    }

    #new-player-name {
      @include box-glow('focus', rgba(#e8ffc6, 0.6));
    }
  }
</style>
