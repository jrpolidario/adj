<template>
  <section id='team-select' class='full-height loader-anchor'>
    <small id='info'>* 2 players per team minimum</small>
    <div
      v-if='getState("currentGamesPlayer").team() != null'
      v-on:click='setIsReady(!getState("currentGamesPlayer").is_ready())'
      id='ready-button'
    >
      <span class='ready-text'>
        <i v-if='getState("currentGamesPlayer").is_ready()' class='fa fa-check' aria-hidden='true'></i>
        <span v-else class='noselect'>Ready</span>
      </span>
    </div>
    <div
      v-bind:class='{ opaque: getState("currentGamesPlayer").is_ready() }'
      id='teams-container'
      class='full-height'
    >
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
  </section>
</template>

<script>
  import { mapActions, mapGetters } from 'vuex'
  import PlayerName from './team_select/PlayerName'

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
        setCurrentTeam(team) {
          this.adjAjax({
            url: Routes.games_player_path({ id: this.getState('currentGamesPlayer').id() }),
            method: 'post',
            data: {
              _method: 'patch',
              games_player: {
                team: team,
                is_ready: false, // also set to false
              }
            }
          })
        },
        setIsReady(value) {
          if (value == true)
            flash('Now waiting for all other players to be ready...', 'info')

          this.adjAjax({
            url: Routes.games_player_path({ id: this.getState('currentGamesPlayer').id() }),
            method: 'post',
            data: {
              _method: 'patch',
              games_player: {
                is_ready: value
              }
            }
          })
        },
        isCurrentTeam(team) {
          return this.getState('currentGamesPlayer').team() == team
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

  #team-select {
    #info {
      position: absolute;
      top: -1.5rem;
      left: 0.2rem;
      color: #aaa;
    }

    #ready-button {
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

      .ready-text {
        color: white;
        font-family: $default-font-header-sans;

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
        cursor: pointer;
        color: #555;
        overflow-y: auto;

        @include box-glow('hover', rgba(grey, 0.4));

        &.active {
          background: rgba($page-base-background-color, 0.7);

          .team-players {
            color: white;
          }
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
