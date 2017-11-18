<template>
  <section id='show-game' class='full-height'>
    <h1 class='hide'>Game #{{ game.id() }}</h1>
    <div class='row full-height collapse'>
      <div class='small-12 medium-6 medium-centered columns full-height loader-anchor'>
        <div v-if='preloaded' class='row full-height collapse'>
          <CardSelect v-if='game && game.attributes.is_started'/>
          <TeamSelect v-else/>
        </div>
        <Loader v-else/>
      </div>
    </div>
  </section>
</template>

<script>
  import { mapActions, mapGetters } from 'vuex'
  import Loader from 'shared/Loader'
  import TeamSelect from './index/TeamSelect.vue'
  import CardSelect from './index/TeamSelect.vue'

  export default {
  	components: { TeamSelect, CardSelect, Loader },
    data () {
      return {
        subscriptionsToBeDestroyed: [],
        callbacksToBeDestroyed: [],
        preloaded: false,
        afterPreload() {
          this.$set(this, 'preloaded', true)
          this.authorise()
        },
        // cards: [
  			// 	{
  			// 		name: 'Dog',
        //     image_url: '/categories/animals/dog.jpg',
        //     category: {
        //       name: 'Animal'
        //     }
  			// 	},
  			// 	{
  			// 		name: 'Cat',
        //     image_url: '/categories/animals/cat.jpg',
        //     category: {
        //       name: 'Animal'
        //     }
  			// 	},
  			// 	{
  			// 		name: 'Mouse',
        //     image_url: '/categories/animals/mouse.jpg',
        //     category: {
        //       name: 'Animal'
        //     }
  			// 	},
        //   {
  			// 		name: 'Pig',
        //     image_url: '/categories/animals/pig.jpg',
        //     category: {
        //       name: 'Animal'
        //     }
  			// 	}
        // ]
      }
    },
    computed: $.extend(
      {
        game() {
          return this.getRecord('Game', this.$route.params.id)
        }
      },
      mapGetters(['getRecord', 'getState'])
    ),
    methods: $.extend(
      {
        authorise() {
          if (this.getState('currentPlayer') &&
            this.getState('currentPlayer').hasGame(this.game) &&
            this.getState('currentGame') == this.game)
            return true

          this.$router.replace({ name: 'forbiddenPath' })
        }
      },
      mapActions(['preloadLiveRecords', 'cleanup'])
    ),
    mounted() {
      this.preloadLiveRecords({
        vue: this,
        recordIds: { 'Game': [this.game.id()] }
      })
    },
    destroyed() {
      this.cleanup({vue: this})
    }
  }
</script>

<style lang='scss' scoped>
  #show-game {
    padding-top: 10%;
    padding-bottom: 10%;
  }
</style>
