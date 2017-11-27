<template>
  <transition
    name='custom-classes-transition'
    enter-active-class='animated fadeIn'
  >
    <section id='about' class='full-height'>
      <h2>About</h2>
      <p>Don't have any card games to play with your friends? Need an icebreaker over a phone conversation? Try and play Adj! No registration required! :)</p>
      <p>Try to guess cards, but only using adjectives, and AND and OR! No other words allowed! Say... "big AND dark", "sour OR sweet, AND round, AND green"!</p>

      <h3>Motivations</h3>
      <p>
        I have been developing <a href='https://github.com/jrpolidario/live_record' target='_blank'>LiveRecord</a> (a Ruby gem) for a while now, but it does not yet showcase a full-fledged sample app that would demonstrate its features. Therefore, during this holiday break, I have embarked on this project, and now is finally finished after three weeks! :) I'm ecstatic on how it turned out!! XD
      </p>

      <h3>Technologies</h3>
      <ul>
        <li><a href='https://github.com/jrpolidario/live_record' target='_blank'>LiveRecord</a></li>
        <li><a href='http://rubyonrails.org/' target='_blank' rel='nofollow'>Ruby on Rails</a></li>
        <li><a href='https://vuejs.org/' target='_blank' rel='nofollow'>Vue JS</a></li>
        <li><a href='https://foundation.zurb.com/' target='_blank' rel='nofollow'>Foundation Zurb</a></li>
      </ul>

      <p>
        <em>If you like this game, would you consider sponsoring a cup of coffee? :)</em>
      </p>
      <p>
        <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&amp;hosted_button_id=Q5MGDZNU4T2YU" rel="nofollow">
          <img src="https://camo.githubusercontent.com/f896f7d176663a1559376bb56aac4bdbbbe85ed1/68747470733a2f2f7777772e70617970616c6f626a656374732e636f6d2f656e5f55532f692f62746e2f62746e5f646f6e61746543435f4c472e676966" alt="paypal" data-canonical-src="https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif" style="max-width:100%;">
        </a>
      </p>
      <p>
        <small>Built with <3 | c/o Jules Roman B. Polidario - 2017 | <a href='https://twitter.com/JRPolidario' rel='nofollow' target='_blank'>@jrpolidario</a></small><br>
        <small>All card-images have CC0 license, and taken from <a href='https://pixabay.com' rel='nofollow' target='_blank'>pixabay.com</a></small>
      </p>
    </section>
  </transition>
</template>

<script>
  export default {
    mounted() {
      this.$store.dispatch('scrollToComponent', this.$el)
    }
  }
</script>

<style lang='scss' scoped>
  @import 'app/assets/stylesheets/imports/variables';

  #about {
    background-color: $page-base-background-color;
    overflow-y: auto;

    a {
      color: darken(#69D2E7, 27);
      font-weight: bold;

      &:hover {
        color: darken(#69D2E7, 32);
      }
    }
  }
</style>
