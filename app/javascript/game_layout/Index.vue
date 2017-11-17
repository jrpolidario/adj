<template>
  <section id='show-game' class='full-height'>
    <div class='row full-height collapse'>
      <div class='small-12 medium-6 medium-centered columns full-height loader-anchor'>
        <div v-if='preloaded' class='row full-height collapse'>
          <Ready v-if='game && game.attributes.is_started'/>
          <Card v-else v-for='card in cards' :card='card'/>
        </div>
        <Loader v-else/>
      </div>
    </div>
  </section>
</template>

<script>
  import { mapActions } from 'vuex'
  import Card from './cards/Card'
  import Loader from 'shared/Loader'

  export default {
  	components: { Card, Loader },
    data () {
      return {
        subscriptionsToBeDestroyed: [],
        callbacksToBeDestroyed: [],
        preloaded: false,
        afterPreload() {
          this.$set(this, 'preloaded', true)
        },
        cards: [
  				{
  					name: 'Dog',
            image_url: '/categories/animals/dog.jpg',
            category: {
              name: 'Animal'
            }
  				},
  				{
  					name: 'Cat',
            image_url: '/categories/animals/cat.jpg',
            category: {
              name: 'Animal'
            }
  				},
  				{
  					name: 'Mouse',
            image_url: '/categories/animals/mouse.jpg',
            category: {
              name: 'Animal'
            }
  				},
          {
  					name: 'Pig',
            image_url: '/categories/animals/pig.jpg',
            category: {
              name: 'Animal'
            }
  				}
        ]
      }
    },
    computed: {
      game() {
        return this.$store.getters.getRecord('Game', this.$route.params.id)
      }
    },
    methods: mapActions(['preloadLiveRecords', 'cleanup']),
    created() {
      this.preloadLiveRecords({
        vue: this,
        recordIds: { 'Game': [this.game.id(), 17, 18, 19] }
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
