<template>
  <section id='team-select' class='full-height loader-anchor'>
    <div v-if='preloaded' class='full-height'>
      <div
        v-bind:class='{ active: isCurrentTeam(1) }'
        v-on:click='setCurrentTeam(1)'
        class='small-12 medium-6 columns team-container'
      >
        <div class='team-players'>
          <PlayerName v-for='(gamesPlayer, index) in teamAGamesPlayers()' :gamesPlayer='gamesPlayer'/>
        </div>
        <h2 class='underlay-text'>
          TEAM A
        </h2>
      </div>
      <div
        v-bind:class='{ active: isCurrentTeam(2) }'
        v-on:click='setCurrentTeam(2)'
        class='small-12 medium-6 columns team-container'
      >
        <div class='team-players'>
          <PlayerName v-for='(gamesPlayer, index) in teamBGamesPlayers()' :gamesPlayer='gamesPlayer'/>
        </div>
        <h2 class='underlay-text'>
          TEAM B
        </h2>
      </div>
      <div
        v-bind:class='{ active: isCurrentTeam(3) }'
        v-on:click='setCurrentTeam(3)'
        class='small-12 medium-6 columns team-container'
      >
        <div class='team-players'>
          <PlayerName v-for='(gamesPlayer, index) in teamCGamesPlayers()' :gamesPlayer='gamesPlayer'/>
        </div>
        <h2 class='underlay-text'>
          TEAM C
        </h2>
      </div>
      <div
        v-bind:class='{ active: isCurrentTeam(4) }'
        v-on:click='setCurrentTeam(4)'
        class='small-12 medium-6 columns team-container'
      >
        <div class='team-players'>
          <PlayerName v-for='(gamesPlayer, index) in teamDGamesPlayers()' :gamesPlayer='gamesPlayer'/>
        </div>
        <h2 class='underlay-text'>
          TEAM D
        </h2>
      </div>
    </div>
    <Loader v-else/>
  </section>
</template>

<script>
  import { mapActions, mapGetters } from 'vuex'
  import PlayerName from './team_select/PlayerName'
  import Loader from 'shared/Loader'

  export default {
    components: { PlayerName, Loader },
    data() {
      return {
        subscriptionsToBeDestroyed: [],
        callbacksToBeDestroyed: [],
        preloaded: false
      }
    },
    computed: $.extend(
      {
        game() {
          return this.$store.getters.getRecord('Game', this.$route.params.id)
        }
      },
      mapGetters(['getState'])
    ),
    methods: $.extend(
      {
        teamAGamesPlayers() {
          return this.game.gamesPlayers().filter((gamesPlayer) => {
            return gamesPlayer.team() == 1
          })
        },
        teamBGamesPlayers() {
          return this.game.gamesPlayers().filter((gamesPlayer) => {
            return gamesPlayer.team() == 2
          })
        },
        teamCGamesPlayers() {
          return this.game.gamesPlayers().filter((gamesPlayer) => {
            return gamesPlayer.team() == 3
          })
        },
        teamDGamesPlayers() {
          return this.game.gamesPlayers().filter((gamesPlayer) => {
            return gamesPlayer.team() == 4
          })
        },
        setCurrentTeam(team) {
          this.adjAjax({
            url: Routes.games_player_path({ id: this.getState('currentGamesPlayer').id() }),
            method: 'post',
            data: {
              _method: 'patch',
              games_player: {
                team: team
              }
            }
          })
        },
        isCurrentTeam(team) {
          return this.getState('currentGamesPlayer').team() == team
        }
      },
      mapActions(['cleanup', 'adjAjax'])
    ),
    mounted() {
      const self = this
      const gamesPlayersSubscription = LiveRecord.Model.all.GamesPlayer.autoload({
        reload: true,
        where: { game_id_eq: this.game.id() },
        callbacks: {
          'after:createOrUpdate': function(gamesPlayer) {
            // also load the associated Player if not yet in store
            let player = LiveRecord.Model.all.Player.all[gamesPlayer.player_id()]

            if (!player) {
              player = new LiveRecord.Model.all.Player({id: gamesPlayer.player_id()})
              player.create({ reload: true })

              const playerCreateCallback = player.addCallback('after:create', function() {
                self.$set(self, 'preloaded', true)
                self.$forceUpdate()
              })

              const playerDestroyCallback = player.addCallback('after:destroy', function() {
                self.$set(self, 'preloaded', true)
                self.$forceUpdate()
              })

              self.callbacksToBeDestroyed.push([player, playerCreateCallback])
              self.callbacksToBeDestroyed.push([player, playerDestroyCallback])
            }
          },
          'after:reload': function(recordIds) {
            self.$set(self, 'preloaded', true)
            self.$forceUpdate()
          }
        }
      })
      this.subscriptionsToBeDestroyed.push([LiveRecord.Model.all.GamesPlayer, gamesPlayersSubscription])
    },
    destroyed() {
      this.cleanup({ vue: this })
    }
  }
</script>

<style lang='scss' scoped>
  @import 'node_modules/foundation-sites/scss/util/util.scss';
  @import 'app/assets/stylesheets/imports/variables';
  @import 'app/assets/stylesheets/imports/mixins';

  #team-select {
    border-radius: 0.5rem;
    overflow: hidden;

    .team-container {
      position: relative;
      cursor: pointer;
      color: #555;

      @include box-glow('hover', rgba(grey, 0.4));

      &.active {
        background: rgba($page-base-background-color, 0.7);

        .team-players {
          color: white;
        }
      }

      @include breakpoint(medium up) {
        height: 50%;
      }

      @include breakpoint(small only) {
        height: 25%;
      }

      .underlay-text {
        opacity: 0.1;
        font-weight: bold;
        z-index: -1;
        margin: 0;
        line-height: 2rem;
      }

      .team-players {
        padding: 1rem;
      }

      &:nth-child(1) {
        border-right: 2px dashed #bbb;
        border-bottom: 2px dashed #bbb;

        .underlay-text {
          position: absolute;
          top: 0.5rem;
          left: 0.5rem;
        }
      }

      &:nth-child(2) {
        border-bottom: 2px dashed #bbb;

        .underlay-text {
          position: absolute;
          top: 0.5rem;
          right: 0.5rem;
        }
      }

      &:nth-child(3) {
        border-right: 2px dashed #bbb;

        .underlay-text {
          position: absolute;
          bottom: 0.5rem;
          left: 0.5rem;
        }
      }

      &:nth-child(4) {
        .underlay-text {
          position: absolute;
          bottom: 0.5rem;
          right: 0.5rem;
        }
      }
    }
  }
</style>
