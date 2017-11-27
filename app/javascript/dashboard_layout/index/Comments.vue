<template>
  <section id='comments' class='full-height loader-anchor'>
    <h2><i class='fa fa-pencil' aria-hidden='true'></i> Chat</h2>
    <div id='comments-container'>
      <ShowComment v-for='(comment, id) in comments' :comment='comment'/>
    </div>
    <NewComment/>
  </section>
</template>

<script>
  import { mapState, mapGetters, mapActions } from 'vuex'
  import ShowComment from './comments/Show'
  import NewComment from './comments/New'
  import moment from 'moment'

  export default {
    components: { ShowComment, NewComment },
    data() {
      return {
        subscriptionsToBeDestroyed: [],
        callbacksToBeDestroyed: []
      }
    },
    computed: Object.assign(
      {},
      mapState({
        comments: (state) => { return state.records.Comment }
      }),
      mapGetters(['getState', 'getRecord'])
    ),
    methods: mapActions(['cleanup']),
    mounted() {
      const self = this

      const commentsSubscription = LiveRecord.Model.all.Comment.subscribe({
        reload: true,
        where: {
          created_at_gteq: moment().subtract(10, 'minute')
        },
        callbacks: {
          'after:create': function(comment) {
            let player = self.getRecord('Player', comment.player_id())

            // if player not yet loaded, load
            if (!player) {
              player = new LiveRecord.Model.all.Player({ id: comment.player_id() })
              const playerCreateCallback = player.addCallback('after:create', function() {
                self.$forceUpdate()
              })
              self.callbacksToBeDestroyed.push([player, playerCreateCallback])
              player.create()
            }
            else {
              self.$forceUpdate()
            }
          }
        }
      })
      this.subscriptionsToBeDestroyed.push([LiveRecord.Model.all.Comment, commentsSubscription])
    },
    destroyed() {
      this.cleanup({ vue: this })
    }
  }
</script>

<style lang='scss' scoped>
  @import 'app/assets/stylesheets/imports/variables';

  #comments {
    background-color: lighten($page-base-background-color, 5);
    display: flex;
    flex-direction: column;

    #comments-container {
      flex-grow: 1;
      overflow-y: auto;
      overflow-x: hidden;
    }
  }
</style>
