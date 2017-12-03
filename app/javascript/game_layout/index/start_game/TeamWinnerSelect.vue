<template>
  <section id='team-winner-select' class='full-height loader-anchor'>
    <small id='info'>* If your team failed to guess the card, now allow other teams to guess once, then choose the team winner! :)</small>
    <div v-on:click='openConfirmTeamWinnerModal(0)' id='no-winner-button'>
      <span class='no-winner-text'>
        <span class='noselect'>No Winner</span>
      </span>
    </div>
    <div
      id='teams-container'
      class='full-height'
    >
      <div
        v-on:click='openConfirmTeamWinnerModal(1)'
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
        v-on:click='openConfirmTeamWinnerModal(2)'
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
        v-on:click='openConfirmTeamWinnerModal(3)'
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
        v-on:click='openConfirmTeamWinnerModal(4)'
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
    <div class='reveal' ref='confirmTeamWinnerModal' data-reveal>
      <p>{{ selectedTeamWinnerText }} is the winner, is this correct?</p>
      <button v-on:click='setWinnerTeam()' class='button'>Ok</button>
      <button class='close-button' data-close aria-label='Close modal' type='button'>
        <span aria-hidden='true'>&times;</span>
      </button>
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
    data() {
      return {
        selectedTeamWinner: null
      }
    },
    computed: Object.assign(
      {
        selectedTeamWinnerText() {
          let text
          switch (this.selectedTeamWinner) {
            case 0:
              text = 'NO ONE'
              break
            case 1:
              text = 'TEAM A'
              break
            case 2:
              text = 'TEAM B'
              break
            case 3:
              text = 'TEAM C'
              break
            case 4:
              text = 'TEAM D'
              break
          }
          return text
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
        openConfirmTeamWinnerModal(team) {
          this.$set(this, 'selectedTeamWinner', team)
          $(this.$refs.confirmTeamWinnerModal).foundation('open')
        },
        setWinnerTeam() {
          this.adjAjax({
            url: Routes.selectable_card_path({ id: this.game.currentSelectableCard().id() }),
            method: 'post',
            data: {
              _method: 'patch',
              selectable_card: {
                team_winner: this.selectedTeamWinner
              }
            }
          })
          $(this.$refs.confirmTeamWinnerModal).foundation('close')
        }
      },
      mapActions(['cleanup', 'adjAjax'])
    ),
    mounted() {
      // vibrate because time has just up
      window.navigator.vibrate(200)
      $(this.$refs.confirmTeamWinnerModal).foundation()
    }
  }
</script>

<style lang='scss' scoped>
  @import 'node_modules/foundation-sites/scss/util/util.scss';
  @import 'app/assets/stylesheets/imports/variables';
  @import 'app/assets/stylesheets/imports/mixins';

  .reveal {
    .button {
      color: white;
      background-color: darken($page-base-background-color, 10);
      margin: 0;

      &:hover {
        background-color: darken($page-base-background-color, 20);
      }
    }
  }

  #team-winner-select {
    #info {
      position: absolute;
      top: -2.0rem;
      left: 0.2rem;
      color: #aaa;
      font-size: 0.7rem;
    }

    #no-winner-button {
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

      .no-winner-text {
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
