<template>
  <div class='small-6 columns card-container'>
    <div
      v-if='card() && card().attributes.category_id != undefined'
      v-on:click='flip'
      class='flip-container full-height noselect'
      v-bind:class='{ flipped: selectableCard().is_front_side_up(), clickable: isClickable }'
    >
    	<div class='flipper full-height'>
    		<div class='front full-height card' v-bind:style='{ backgroundImage: "url(" + card().imageUrl() + ")" }'>
          <div class='name'>
    			  {{ card().name() }}
          </div>
    		</div>
    		<div class='back full-height card'>
          <div class='name'>
    			  {{ card().category().name() }}
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
          return this.isCurrentTurn
        },
        isCurrentTurn() {
          return this.game.attributes.current_turn_games_player_id == this.getState('currentGamesPlayer').id()
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
                  is_front_side_up: !this.selectableCard().is_front_side_up()
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
  // @import 'stylesheets/imports/variables';

  .card-container {
    height: 50%;
    padding: 0.5em !important;

    .flip-container {
      &.clickable:hover {
        opacity: 0.6;
        cursor: pointer;
      }

      .card {
        background: #fafafa;
        border-radius: 5px;
        background-position: center center;
        background-size: cover;
        box-shadow: 0 1px 1px rgba(0,0,0,0.2);

        .name {
          font-size: 2em;
          left: 50%;
          position: absolute;
          transform: translateX(-50%);
        }

        &.front .name {
          bottom: 0;
          color: rgba(255,255,255,0.8);
          text-shadow: 0 0 2px rgba(0,0,0,0.6);
        }

        &.back .name {
          color: #555;
          top: 50%;
          transform: translate(-50%, -50%);
        }
      }
    }
  }
</style>
