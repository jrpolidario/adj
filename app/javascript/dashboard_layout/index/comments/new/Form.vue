<template>
  <form
    id='comment-form'
    v-bind:action='formAction'
    v-bind:method='["patch", "put", "delete"].includes(formMethod) ? "post" : formMethod'
    data-remote='true'
    data-type='json'
    v-on:ajax:success='onSubmitSuccess'
    v-on:ajax:error='onSubmitError'
  >
    <input v-if='["patch", "put", "delete"].includes(formMethod)' name='_method' type='hidden' v-bind:value='formMethod'/>
    <div class='input-group'>
      <input
        type='text'
        name='comment[content]'
        ref='content'
        v-bind:placeholder='getState("currentPlayer") ? "Send a message" : "Enter name first"'
        v-bind:disabled='!getState("currentPlayer")'
        v-model='formValues.content'
      ></input>
      <button type='submit' class='button input-group-button' v-bind:disabled='!getState("currentPlayer")'>
        <i class='fa fa-send' aria-hidden='true'></i>
      </button>
    </div>
  </form>
</template>

<script>
  import { mapGetters } from 'vuex'

  export default {
    props: {
      comment: {
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
      { formValues() { return this.comment.attributes } },
      mapGetters(['getState'])
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

        this.$set(this.formValues, 'content', '')

        this.onSubmitSuccessCallback(data, status, xhr)
      },
      onSubmitError(event) {
        const data = event.detail[0]
        const status = event.detail[1]
        const xhr = event.detail[2]

        const errors = data
        const $form = $(event.currentTarget)

        for (let attribute in errors) {
          let $attributeInput = $form.find(':input').filter('[name="comment[' + attribute + ']"]')
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
    }
  }
</script>

<style lang='scss' scoped>
  form#comment-form {
    .error {
      border-bottom: 1px solid rgba(#E63946, 1);
    }

    input, input:focus {
      // $input-border-size: 1px;
      border: 1px solid rgba(255,255,255,0.3);
      box-shadow: none;
      border-radius: 0.5rem 0 0 0.5rem;
      background: rgba(255,255,255, 0.2);
      color: white;
      // margin: -($input-border-size);
      // margin-top: 1rem;
      margin: 0;
    }

    .input-group {
      margin-bottom: 0;
    }

    button.button {
      background: rgba(0,0,0,0.1);
      border: 1px solid rgba(0,0,0,0.04);
      border-radius: 0 0.5rem 0.5rem 0;

      &:hover {
        background: rgba(0,0,0,0.2);
      }
    }
  }
</style>
