<template>
  <div id='new-comment'>
    <CommentForm
      :comment='comment'
      :formAction='commentsPath'
      :formMethod='"post"'
      :onSubmitSuccessCallback='onSubmitSuccessCallback.bind(this)'
    />
  </div>
</template>

<script>
  import { mapGetters, mapActions } from 'vuex'
  import CommentForm from './new/Form'

  export default {
    components: { CommentForm },
    data() {
      const self = this

      return {
        comment: new LiveRecord.Model.all.Comment(),
        subscriptionsToBeDestroyed: [],
        callbacksToBeDestroyed: [],
        onSubmitSuccessCallback(data, status, xhr) {
          // do nothing else
        }
      }
    },
    computed: $.extend(
      {
        commentsPath: () => Routes.comments_path()
      },
      mapGetters(['getState', 'getRecord'])
    ),
    methods: mapActions(['cleanup']),
    destroyed() {
      this.cleanup({ vue: this })
    }
  }
</script>

<style lang='scss' scoped>
  #new-comment {
    margin-top: 1rem;
  }
</style>
