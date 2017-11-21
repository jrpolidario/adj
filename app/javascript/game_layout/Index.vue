<template>
  <section id='show-game' class='full-height'>
    <h1 class='hide'>Game #{{ game.id() }}</h1>
    <div class='row full-height collapse'>
      <div class='small-12 medium-6 medium-centered columns full-height loader-anchor'>
        <div v-if='preloaded' class='row full-height collapse'>
          <CardSelect v-if='game && game.attributes.is_started' :game='game'/>
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
  import CardSelect from './index/CardSelect.vue'

  export default {
  	components: { TeamSelect, CardSelect, Loader },
    data () {
      return {
        subscriptionsToBeDestroyed: [],
        callbacksToBeDestroyed: [],
        preloaded: false,
        afterPreload() {
          const self = this
          self.$store.commit('setState', { currentGame: self.game })

          const gamesPlayerSubscription = LiveRecord.Model.all.GamesPlayer.autoload({
            reload: true,
            where: {
              player_id_eq: self.getState('currentPlayer').id(),
              game_id_eq: this.game.id()
            },
            callbacks: {
              'after:createOrUpdate': function(gamesPlayer) {
                self.$store.commit('setState', { currentGamesPlayer: gamesPlayer })

                self.$set(self, 'preloaded', true)
                self.authorise()
              }
            }
          })
          self.subscriptionsToBeDestroyed.push([LiveRecord.Model.all.GamesPlayer, gamesPlayerSubscription])
        }
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
      const self = this
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
