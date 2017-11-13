<template>
<div class='small-6 columns card-container'>
  <!-- <div class='card full-height' v-bind:style='{ backgroundImage: "url(" + card.image_url + ")" }'>
    {{ card.name }}
  </div> -->

  <div class='flip-container full-height noselect' v-on:click='flip'>
  	<div class='flipper full-height'>
  		<div class='front full-height card' v-bind:style='{ backgroundImage: "url(" + card.image_url + ")" }'>
        <div class='name'>
  			  {{ card.name }}
        </div>
  		</div>
  		<div class='back full-height card'>
        <div class='name'>
  			  {{ card.category.name }}
        </div>
  		</div>
  	</div>
  </div>
</div>
</template>

<script>
export default {
  props: {
    card: {
      type: Object,
      required: true
    }
  },
  methods: {
    flip: function(event) {
      $(event.currentTarget).toggleClass('flipped');
    }
  }
}
</script>

<style lang='scss' scoped>
// @import 'stylesheets/imports/variables';

.card-container {
  height: 50%;
  padding: 0.5em !important;

  .card {
    background: #fafafa;
    border-radius: 5px;
    background-position: center center;
    background-size: cover;
    box-shadow: 0 1px 1px rgba(0,0,0,0.2);
    cursor: pointer;

    &:hover {
      opacity: 0.6;
    }

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
</style>
