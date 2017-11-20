<template>
  <div class='show-comment'>
    <div class='comment-header'>
      <span class='player-name'>
        @{{ comment.player().name() }}
      </span>
      <span class='timestamp'>
        {{ commentCreatedAt }}
      </span>
    </div>
    <span class='comment-content'>
      {{ comment.content() }}
    </span>
    <div class='sticky-corner'>
    </div>
  </div>
</template>

<script>
  import { mapGetters, mapActions } from 'vuex'
  import moment from 'moment'

  export default {
    props: {
      comment: {
        type: Object,
        required: true
      }
    },
    data() {
      return {
        commentCreatedAt: null
      }
    },
    computed: mapGetters(['getRecord', 'getState']),
    mounted() {
      // update timestamp every five seconds
      const updateCommentCreatedAt = () => {
        this.$set(this, 'commentCreatedAt', moment(this.comment.created_at()).fromNow())
      }
      updateCommentCreatedAt()
      setInterval(function() {
        updateCommentCreatedAt()
      }, 5000)

    }
  }
</script>

<style lang='scss' scoped>
  @import 'app/assets/stylesheets/imports/variables';

  .show-comment {
    border: 1px solid white;
    padding: 1rem;
    padding-top: 2rem;
    border-radius: 0.2rem 0.2rem 1rem 0.2rem;
    position: relative;
    margin-top: 1rem;

    .comment-header {
      position: absolute;
      top: 0;
      left: 0;
      padding: 0.1em 0.2em;
      font-size: 0.8em;
      font-family: $default-font-header-sans;
      width: 100%;

      .player-name {
        float: left;
      }

      .timestamp {
        float: right;
      }
    }

    .comment-content {
      word-break: break-all;
    }

    .sticky-corner {
      position: absolute;
      bottom: 0.1rem;
      right: -0.2rem;

      border-bottom: 0.75rem solid white;
      border-right: 0.75rem solid transparent;
      border-left: 0.75rem solid transparent;
      width: 0;
      height: 0;
      transform: rotate(-40deg);
      border-radius: 100%;
    }
  }
</style>
