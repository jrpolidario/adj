<template>
  <form
    id='game-form'
    v-bind:action='formAction'
    v-bind:method='["patch", "put", "delete"].includes(formMethod) ? "post" : formMethod'
    data-remote='true'
    data-type='json'
    v-on:ajax:success='onSubmitSuccess'
    v-on:ajax:error='onSubmitError'
  >
    <input v-if='["patch", "put", "delete"].includes(formMethod)' name='_method' type='hidden' v-bind:value='formMethod'/>
    <input name='game[games_players_attributes][][player_id]' type='hidden' v-model='formValues.games_players_attributes.player_id'/>
    <input
      type='password'
      name='game[password]'
      ref='password'
      placeholder='Enter game password'
      v-model='formValues.password'
    ></input>
    <input
      type='password'
      name='game[password_confirmation]'
      placeholder='Re-enter password'
      v-model='formValues.password_confirmation'
    ></input>
    <input type='submit' class='button'></input>
  </form>
</template>

<script>
  import { mapGetters } from 'vuex'

  export default {
    props: {
      game: {
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
        type: Function,
        default: () => {}
      }
    },
    computed: Object.assign(
      {
        formValues() {
          const self = this
          return $.extend( // clone
            {
              games_players_attributes: {
                player_id: self.getState('currentPlayer').id()
              }
            },
            this.game.attributes
          )
        }
      },
      mapGetters([
        'getState'
      ])
    ),
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

        this.$set(this.formValues, 'password', '')
        this.$set(this.formValues, 'password_confirmation', '')

        this.onSubmitSuccessCallback(data, status, xhr)
      },
      onSubmitError(event) {
        const data = event.detail[0]
        const status = event.detail[1]
        const xhr = event.detail[2]

        const errors = data
        const $form = $(event.currentTarget)

        for (let attribute in errors) {
          let $attributeInput = $form.find(':input').filter('[name="game[' + attribute + ']"]')
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
      }
    },
    mounted() {
      // focus the "password" input field
      this.$refs.password.focus()
    }
  }
</script>

<style lang='scss' scoped>
  form#game-form {
    .error {
      border-bottom: 1px solid rgba(#E63946, 1);
    }

    input, input:focus {
      // $input-border-size: 1px;
      border: 1px solid rgba(255,255,255,0.3);
      box-shadow: none;
      border-radius: 0.15rem;
      background: rgba(255,255,255, 0.2);
      color: white;
      // margin: -($input-border-size);
      // margin-top: 1rem;

      &.button {
        background: rgba(0,0,0,0.15);
        border: 1px solid rgba(0,0,0,0.04);

        &:hover {
          background: rgba(0,0,0,0.4);
        }
      }
    }
  }
</style>
