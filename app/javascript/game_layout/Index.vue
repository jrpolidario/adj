<template>
  <transition
    name='custom-classes-transition'
    enter-active-class='animated zoomIn'
  >
    <section v-if='loadCounter == loadTotal' id='game-layout' class='full-height'>
      <h1 class='hide'>Game #{{ game.id() }}</h1>
      <div class='row full-height collapse'>
        <div class='small-12 medium-6 medium-centered columns full-height loader-anchor'>
          <div class='row full-height collapse'>
            <StartGame v-if='game && game.attributes.is_started' :game='game'/>
            <TeamSelect v-else :game='game'/>
          </div>
        </div>
      </div>
    </section>
    <Loader v-else/>
  </transition>
</template>

<script>
  import { mapActions, mapGetters } from 'vuex'
  import Loader from 'shared/Loader'
  import TeamSelect from './index/TeamSelect.vue'
  import StartGame from './index/StartGame.vue'

  export default {
  	components: { TeamSelect, StartGame, Loader },
    data () {
      return {
        subscriptionsToBeDestroyed: [],
        callbacksToBeDestroyed: [],
        loadCounter: 0,
        loadTotal: 0,
        afterPreload() {
          const self = this
          // self.authorise()
          self.$store.commit('setState', { currentGame: self.game })

          const gamesPlayersSubscription = LiveRecord.Model.all.GamesPlayer.autoload({
            reload: true,
            where: { game_id_eq: self.game.id() },
            callbacks: {
              'after:createOrUpdate': function(gamesPlayer) {
                if (gamesPlayer.player_id() == self.getState('currentPlayer').id())
                  self.$store.commit('setState', { currentGamesPlayer: gamesPlayer })

                // also load the associated Player if not yet in store
                let player = LiveRecord.Model.all.Player.all[gamesPlayer.player_id()]

                if (!player) {
                  player = new LiveRecord.Model.all.Player({ id: gamesPlayer.player_id() })

                  const createPlayerCallback = player.addCallback('after:create', function(player) {
                    self.loadCounter++
                    self.nestedForceUpdate(self)
                  })
                  self.callbacksToBeDestroyed.push([player, createPlayerCallback])
                  self.loadTotal++

                  const destroyPlayerCallback = player.addCallback('after:destroy', function(card) {
                    self.nestedForceUpdate(self)
                  })
                  self.callbacksToBeDestroyed.push([player, destroyPlayerCallback])

                  player.create()
                }
                self.nestedForceUpdate(self)
              },
              'after:reload': function(recordIds) {
                self.loadCounter++
                self.nestedForceUpdate(self)
              }
            }
          })
          self.loadTotal++
          self.subscriptionsToBeDestroyed.push([LiveRecord.Model.all.GamesPlayer, gamesPlayersSubscription])

          const selectableCardsSubscription = LiveRecord.Model.all.SelectableCard.autoload({
            reload: true,
            where: { game_id_eq: self.game.id() },
            callbacks: {
              'after:createOrUpdate': function(selectableCard) {
                // also load the associated Card if not yet in store
                let card = LiveRecord.Model.all.Card.all[selectableCard.card_id()]

                if (!card) {
                  card = new LiveRecord.Model.all.Card({ id: selectableCard.card_id() })

                  const createCardCallback = card.addCallback('after:create', function(card) {
                    self.loadCounter++
                    self.nestedForceUpdate(self)
                  })
                  self.callbacksToBeDestroyed.push([card, createCardCallback])
                  self.loadTotal++

                  const destroyCardCallback = card.addCallback('after:destroy', function(card) {
                    self.nestedForceUpdate(self)
                  })
                  self.callbacksToBeDestroyed.push([card, destroyCardCallback])

                  card.create()
                }
                self.nestedForceUpdate(self)
              },
              'after:reload': function(recordIds) {
                self.loadCounter++
                self.nestedForceUpdate(self)
              }
            }
          })
          self.loadTotal++
          self.subscriptionsToBeDestroyed.push([LiveRecord.Model.all.SelectableCard, selectableCardsSubscription])

          const deckCardsSubscription = LiveRecord.Model.all.DeckCard.autoload({
            reload: true,
            where: { game_id_eq: self.game.id() },
            callbacks: {
              'after:createOrUpdate': function(deckCard) {
                // also load the associated Card if not yet in store
                let card = LiveRecord.Model.all.Card.all[deckCard.card_id()]

                if (!card) {
                  card = new LiveRecord.Model.all.Card({ id: deckCard.card_id() })

                  const createCardCallback = card.addCallback('after:create', function(card) {
                    self.loadCounter++
                    self.nestedForceUpdate(self)
                  })
                  self.callbacksToBeDestroyed.push([card, createCardCallback])
                  self.loadTotal++

                  const destroyCardCallback = card.addCallback('after:destroy', function(card) {
                    self.nestedForceUpdate(self)
                  })
                  self.callbacksToBeDestroyed.push([card, destroyCardCallback])

                  card.create()
                }
                self.nestedForceUpdate(self)
              },
              'after:reload': function(recordIds) {
                self.loadCounter++
                self.nestedForceUpdate(self)
              }
            }
          })
          self.loadTotal++
          self.subscriptionsToBeDestroyed.push([LiveRecord.Model.all.DeckCard, deckCardsSubscription])

          const categoriesSubscription = LiveRecord.Model.all.Category.autoload({
            reload: true,
            callbacks: {
              'after:reload': function(recordIds) {
                self.loadCounter++
                self.nestedForceUpdate(self)
              }
            }
          })
          self.loadTotal++
          self.subscriptionsToBeDestroyed.push([LiveRecord.Model.all.Category, categoriesSubscription])
        }
      }
    },
    computed: $.extend(
      {
        game() { return this.getRecord('Game', this.$route.params.id) }
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
        },
        nestedForceUpdate(vueParent) {
          const self = this
          vueParent.$forceUpdate()
          vueParent.$children.forEach((vueChild) => {
            self.nestedForceUpdate(vueChild)
          })
        }
      },
      mapActions(['preloadLiveRecords', 'cleanup'])
    ),
    mounted() {
      const self = this
      this.preloadLiveRecords({
        vue: this,
        recordIds: { 'Game': [self.$route.params.id] }
      })
    },
    destroyed() {
      this.cleanup({ vue: this })
    }
  }
</script>

<!-- GLOBAL STYLES FOR GAME LAYOUT -->
<style lang='scss'>
  #game-layout {
    padding-top: 10%;
    padding-bottom: 10%;
  }
</style>
