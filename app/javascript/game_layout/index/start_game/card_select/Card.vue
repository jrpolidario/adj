<template>
  <div class='small-6 columns card-container'>
    <transition
      name='custom-classes-transition'
      enter-active-class='animated rollIn'
      leave-active-class='animated rollOut'
    >
      <div
        v-if='card() && card().attributes.category_id != undefined'
        v-on:click='flip'
        class='flip-container full-height noselect'
        v-bind:class='{ flipped: isFlipped(), clickable: isClickable(), greyed: isGreyed() }'
      >
      	<div class='flipper full-height'>
      		<div class='front full-height card' v-bind:style='{ backgroundImage: "url(" + card().imageUrl() + ")" }'>
            <div v-if='card().image_source_url()' class='card-source-url'>
              <a title='image source' v-bind:href='card().image_source_url()' target='_blank' rel='nofollow'>
                <i class='fa fa-external-link' aria-hidden='true'></i>
              </a>
            </div>
            <div class='card-name'>
      			  {{ card().name() }}
            </div>
      		</div>
      		<div class='back full-height card'>
            <div class='bomb' v-if='selectableCard().is_bomb()'>
              <img alt='bomb' src='/non_digest_assets/bomb.svg'>
            </div>
            <div class='category-name-and-score'>
              <div class='category-name'>
                <span class='question' v-if='selectableCard().is_question()'>
                  ?
                </span>
                <span v-else>
                  {{ card().category().name() }}
                </span>
              </div>
              <div class='score'>
                <i v-for='score in selectableCard().score()' class='fa fa-star' aria-hidden='true'></i>
              </div>
            </div>
      		</div>
      	</div>
      </div>
    </transition>
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
        isCurrentTurn() {
          return this.game.attributes.current_turn_games_player_id == this.getState('currentGamesPlayer').id()
        }
      },
      mapGetters(['getRecord', 'getState'])
    ),
    methods: Object.assign(
      {
        flip: function(event) {
          if (this.isClickable()) {
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
        },
        isClickable() {
          // clickable if current turn and not yet selected any card
          const selectedSelectableCard = this.getState('currentGame').selectableCards().find((selectableCard) => {
            return selectableCard.is_selected()
          })
          return this.isCurrentTurn && !selectedSelectableCard
        },
        isFlipped() {
          return (this.isCurrentTurn && this.selectableCard().is_selected()) ||
            (!this.isCurrentTurn && this.selectableCard().is_time_is_up())
        },
        isGreyed() {
          return this.game.currentSelectableCard() && !this.selectableCard().is_selected()
        }
      },
      mapActions(['adjAjax'])
    )
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

      &.greyed {
        opacity: 0.2;
      }

      .card {
        // background: #fafafa;
        background: darken($page-base-background-color, 10);
        border-radius: 5px;
        background-position: center center;
        background-size: cover;
        box-shadow: 0 1px 1px rgba(0,0,0,0.2);

        .bomb {
          position: absolute;
          bottom: 4%;
          left: 50%;
          width: 25%;
          height: auto;
          opacity: 0.7;
          transform: translateX(-40%);
        }

        .card-source-url {
          position: absolute;
          top: 0;
          padding-left: 0.2rem;

          a {
            color: white;
            text-shadow: 0 0 0.1em rgba(black, 0.6);

            &:hover {
              color: mix(white, blue, 80%)
            }
          }
        }

        .card-name, .category-name-and-score {
          font-size: 2em;
          left: 50%;
          position: absolute;
          transform: translateX(-50%);
          text-align: center;
          font-weight: bold;
        }

        &.front .card-name {
          bottom: 0;
          color: rgba(255,255,255,0.8);
          text-shadow: 0 0 0.2em rgba(0,0,0,0.8);
        }

        &.back .category-name-and-score {
          color: #fff;
          top: 50%;
          transform: translate(-50%, -50%);
          text-shadow: 0.06em 0.06em 0 rgba(black, 0.2);

          .question {
            color: lighten(purple, 62);
            font-weight: bold;
          }

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
