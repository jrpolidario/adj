<template>
  <div class='small-6 columns card-container'>
    <div
      v-if='card() && card().attributes.category_id != undefined'
      v-on:click='flip'
      class='flip-container full-height noselect'
      v-bind:class='{ flipped: isFlipped, clickable: isClickable, highlighted: isHighlighted }'
    >
    	<div class='flipper full-height'>
    		<div class='front full-height card' v-bind:style='{ backgroundImage: "url(" + card().imageUrl() + ")" }'>
          <div class='card-name'>
    			  {{ card().name() }}
          </div>
    		</div>
    		<div class='back full-height card'>
          <div class='category-name-and-score'>
            <div class='category-name'>
    			    {{ card().category().name() }}
            </div>
            <div class='score'>
              <i v-for='score in card().score()' class='fa fa-star' aria-hidden='true'></i>
            </div>
          </div>
    		</div>
    	</div>
    </div>
  </div>
</template>

<script>
  import { mapActions, mapGetters } from 'vuex'

  export default {
    props: {
      game: {
        type: Object,
        required: true
      },
      position: {
        type: Number,
        required: true
      }
    },
    computed: Object.assign(
      {
        isClickable() {
          // clickable if current turn and not yet selected any card
          const selectedSelectableCard = this.getState('currentGame').selectableCards().find((selectableCard) => {
            return selectableCard.is_selected()
          })
          return this.isCurrentTurn && !selectedSelectableCard
        },
        isCurrentTurn() {
          return this.game.attributes.current_turn_games_player_id == this.getState('currentGamesPlayer').id()
        },
        isFlipped() {
          return this.isCurrentTurn && this.selectableCard().is_selected()
        },
        isHighlighted() {
          return this.selectableCard().is_selected()
        }
      },
      mapGetters(['getRecord', 'getState'])
    ),
    methods: Object.assign(
      {
        flip: function(event) {
          if (this.isClickable) {
            // push flip action to server
            this.adjAjax({
              url: Routes.selectable_card_path({ id: this.selectableCard().id() }),
              method: 'post',
              data: {
                _method: 'patch',
                selectable_card: {
                  is_selected: true
                }
              }
            })
          }
        },
        selectableCard() {
          const matchingSelectableCard = this.game.selectableCards().find((selectableCard) => {
            return selectableCard.position() == this.position
          })
          if (matchingSelectableCard)
            return matchingSelectableCard
        },
        card() {
          if (this.selectableCard())
            return this.selectableCard().card()
        }
      },
      mapActions(['adjAjax'])
    ),
    mounted() {
      window.asdf = this
    }
  }
</script>

<style lang='scss' scoped>
  @import 'app/assets/stylesheets/imports/variables';
  @import 'app/javascript/shared/mixins.scss';

  .card-container {
    height: 50%;
    padding: 0.5em !important;

    .flip-container {
      &.clickable:hover {
        opacity: 0.6;
        cursor: pointer;
      }

      &.highlighted {
        @include box-glow(null, $page-base-background-color);
      }

      .card {
        background: #fafafa;
        border-radius: 5px;
        background-position: center center;
        background-size: cover;
        box-shadow: 0 1px 1px rgba(0,0,0,0.2);

        .card-name, .category-name-and-score {
          font-size: 2em;
          left: 50%;
          position: absolute;
          transform: translateX(-50%);
          text-align: center;
        }

        &.front .card-name {
          bottom: 0;
          color: rgba(255,255,255,0.8);
          text-shadow: 0 0 2px rgba(0,0,0,0.6);
        }

        &.back .category-name-and-score {
          color: #555;
          top: 50%;
          transform: translate(-50%, -50%);

          .score {
            font-size: 0.6em;
            text-shadow: 0 0 2px rgba(darken(gold, 10), 0.4);
            color: gold;
          }
        }
      }
    }
  }
</style>
