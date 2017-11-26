<template>
  <section id='end-game' class='full-height loader-anchor'>
    <small id='info'>* Congratulations! :)</small>
    <router-link tag='div' :to='{ name: "rootPath" }' id='return-button'>
      <span class='return-text'>
        <span class='noselect'>Lobby</span>
      </span>
    </router-link>
    <div
      id='teams-container'
      class='full-height'
    >
      <div
        v-bind:class='{ winner: isTeamWinner(1) }'
        class='small-12 medium-6 columns team-container'
      >
        <div class='team-players'>
          <PlayerName v-for='(gamesPlayer, index) in teamAGamesPlayers()' :gamesPlayer='gamesPlayer'/>
        </div>
        <h2 class='underlay-text'>
          TEAM A
          <div v-if='game.teamScore(1)'>{{ game.teamScore(1) }} Pts</div>
        </h2>
      </div>
      <div
        v-bind:class='{ winner: isTeamWinner(2) }'
        class='small-12 medium-6 columns team-container'
      >
        <div class='team-players'>
          <PlayerName v-for='(gamesPlayer, index) in teamBGamesPlayers()' :gamesPlayer='gamesPlayer'/>
        </div>
        <h2 class='underlay-text'>
          TEAM B
          <div v-if='game.teamScore(2)'>{{ game.teamScore(2) }} Pts</div>
        </h2>
      </div>
      <div
        v-bind:class='{ winner: isTeamWinner(3) }'
        class='small-12 medium-6 columns team-container'
      >
        <div class='team-players'>
          <PlayerName v-for='(gamesPlayer, index) in teamCGamesPlayers()' :gamesPlayer='gamesPlayer'/>
        </div>
        <h2 class='underlay-text'>
          TEAM C
          <div v-if='game.teamScore(3)'>{{ game.teamScore(3) }} Pts</div>
        </h2>
      </div>
      <div
        v-bind:class='{ winner: isTeamWinner(4) }'
        class='small-12 medium-6 columns team-container'
      >
        <div class='team-players'>
          <PlayerName v-for='(gamesPlayer, index) in teamDGamesPlayers()' :gamesPlayer='gamesPlayer'/>
        </div>
        <h2 class='underlay-text'>
          TEAM D
          <div v-if='game.teamScore(4)'>{{ game.teamScore(4) }} Pts</div>
        </h2>
      </div>
    </div>
  </section>
</template>

<script>
  import { mapActions, mapGetters } from 'vuex'
  import PlayerName from '../team_select/PlayerName'

  export default {
    components: { PlayerName },
    props: {
      game: {
        type: Object,
        required: true
      }
    },
    computed: mapGetters(['getState']),
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
        isTeamWinner(team) {
          return team == this.game.winner()[0]
        },
        returnToDashboard() {

        }
      },
      mapActions(['cleanup', 'adjAjax'])
    )
  }
</script>

<style lang='scss' scoped>
  @import 'node_modules/foundation-sites/scss/util/util.scss';
  @import 'app/assets/stylesheets/imports/variables';
  @import 'app/assets/stylesheets/imports/mixins';

  #end-game {
    #info {
      position: absolute;
      top: -1.5rem;
      left: 0.2rem;
      color: #aaa;
    }

    #return-button {
      border-radius: 50%;
      height: 5rem;
      width: 5rem;
      z-index: 1;

      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%,-50%);
      background: $page-base-background-color;
      box-shadow: 0 0 0.2rem rgba(darken($page-base-background-color,30),0.6);

      cursor: pointer;

      &:hover {
        background: darken($page-base-background-color, 10);
      }

      .return-text {
        color: white;
        font-family: $default-font-header-sans;
        text-align: center;

        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%,-50%);

        .fa-check {
          font-size: 2rem;
        }
      }
    }

    #teams-container {
      border-radius: 0.5rem;
      overflow: hidden;

      &.opaque {
        opacity: 0.2;
      }

      .team-container {
        position: relative;
        color: #555;
        overflow-y: auto;

        &.winner {
          background-color: rgba(lighten(gold, 20), 0.2);
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

        @include breakpoint(medium up) {
          height: 50%;

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

        @include breakpoint(small only) {
          height: 25%;

          border-bottom: 1px dashed #bbb;
          border-top: 1px dashed #bbb;

          .underlay-text {
            position: absolute;
            top: 0.5rem;
            right: 0.5rem;
          }
        }
      }
    }
  }
</style>
