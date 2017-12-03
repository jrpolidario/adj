<template>
  <div id='card-select' class='full-height'>
    <transition
      name='custom-classes-transition'
      enter-active-class='animated bounceInUp'
    >
      <div v-if='isCurrentTurn' id='info'>
        * Your turn! :)
      </div>
    </transition>
    <div id='game-status'>
      <span class='status-text'>Cards Left: {{ game.deckCards().length }}</span>
    </div>
    <Card
      v-for='position in [1, 2, 3, 4]'
      :game='game'
      :position='position'
    />
    <Timer v-if='game.currentSelectableCard()' :game='game'/>
    <div
      v-if='isCurrentTurn && game.currentSelectableCard() && !game.currentSelectableCard().is_time_is_up()'
      v-on:click='setIsTimeIsUp(true)'
      id='done-button'
    >
      <span class='done-text'>
        <span class='noselect'>Skip</span>
      </span>
    </div>
    <div id='scores'>
      Scores
      <span
        v-if='game.teamPlayers(1).length > 0'
        v-bind:class='{ current: getState("currentGamesPlayer").team() == 1 }'
        class='team-score'
      >A: {{ game.teamScore(1) }}</span>
      <span
        v-if='game.teamPlayers(2).length > 0'
        v-bind:class='{ current: getState("currentGamesPlayer").team() == 2 }'
        class='team-score'
      >B: {{ game.teamScore(2) }}</span>
      <span
        v-if='game.teamPlayers(3).length > 0'
        v-bind:class='{ current: getState("currentGamesPlayer").team() == 3 }'
        class='team-score'
      >C: {{ game.teamScore(3) }}</span>
      <span
        v-if='game.teamPlayers(4).length > 0'
        v-bind:class='{ current: getState("currentGamesPlayer").team() == 4 }'
        class='team-score'
      >D: {{ game.teamScore(4) }}</span>
    </div>
    <div id='lobby-link'>
      <router-link :to="{ name: 'rootPath', hash: '#middle-pane' }">Lobby</router-link>
    </div>
  </div>
</template>

<script>
  import { mapActions, mapGetters } from 'vuex'
  import Card from './card_select/Card'
  import Timer from './card_select/Timer'

  export default {
    components: { Card, Timer },
    props: {
      game: {
        type: Object,
        required: true
      }
    },
    data() {
      return {
        subscriptionsToBeDestroyed: [],
        callbacksToBeDestroyed: [],
      }
    },
    computed: $.extend(
      {
        isCurrentTurn() {
          return this.game.attributes.current_turn_games_player_id == this.getState('currentGamesPlayer').id()
        }
      },
      mapGetters(['getRecord', 'getState'])
    ),
    methods: Object.assign(
      {
        setIsTimeIsUp(value) {
          this.adjAjax({
            url: Routes.selectable_card_path({ id: this.game.currentSelectableCard().id() }),
            method: 'post',
            data: {
              _method: 'patch',
              selectable_card: {
                is_time_is_up: value
              }
            }
          })
        }
      },
      mapActions(['cleanup', 'adjAjax'])
    ),
    mounted() {
      const createDeckCardCallback = LiveRecord.Model.all.DeckCard.addCallback('after:create', () => {
        this.$forceUpdate()
      })
      this.callbacksToBeDestroyed.push([LiveRecord.Model.all.DeckCard, createDeckCardCallback])

      const destroyDeckCardCallback = LiveRecord.Model.all.DeckCard.addCallback('after:destroy', () => {
        this.$forceUpdate()
      })
      this.callbacksToBeDestroyed.push([LiveRecord.Model.all.DeckCard, destroyDeckCardCallback])
    },
    destroyed() {
      this.cleanup({ vue: this })
    }
  }
</script>

<style lang='scss' scoped>
  @import 'app/assets/stylesheets/imports/variables';

  #card-select {
    position: relative;

    #info, #game-status, #scores, #lobby-link {
      position: absolute;
      color: #aaa;
    }

    #info, #game-status {
      top: -1.5rem;
    }

    #scores {
      bottom: -1.5rem;
      left: 0.5em;
      font-weight: bold;

      .current {
        background-color: lighten(yellow, 40);
      }
    }

    #lobby-link {
      $background-color: mix($page-base-background-color, blue, 70%);
      bottom: -2.0rem;
      right: 0.5rem;
      font-weight: bold;
      border: 1px solid darken($background-color, 10);
      border-radius: 0.2rem;
      background-color: $background-color;
      padding: 0.2rem 0.4rem;

      &:hover {
        background-color: darken($background-color, 10);
      }

      a {
        color: white;
      }
    }

    #info {
      left: 0.5rem;
    }

    #game-status {
      right: 0.5rem;
      font-weight: bold;
    }

    #scores, #game-status {
      .team-score, .status-text {
        border-right: 1px solid #ddd;
        padding-right: 0.4em;
        padding-left: 0.4em;

        &:first-child {
          border-left: 1px solid #ddd;
        }
      }
    }

    #done-button {
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

      .done-text {
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
  }
</style>
