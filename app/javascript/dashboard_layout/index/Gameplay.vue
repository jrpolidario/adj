<template>
  <transition
    name='custom-classes-transition'
    enter-active-class='animated fadeIn'
  >
    <section id='game-play' class='full-height'>
      <h2>Gameplay</h2>
      <ol>
        <li>
          Requires at least 2 players to play, and both should have smartphones--or any device with a browser--that have <strong>internet</strong><br>
          <em><small>You can set-up a mobile hotspot with your own phone if your playmates do not have internet</small></em>
        </li>
        <li>
          While in the lobby, create a Player by entering a name, then click 'New Game', and enter a password. Then, share that password to your playmates. They themselves also need to create a Player, but then afterwards they would need to click the newly created game that will pop-up on the 'Lobby' page, and enter the password to join the game.
        </li>
        <li>
          Choose your Team in the Team Selection screen, and click 'Ready' afterwards. If everyone has clicked 'Ready' already, the game will then start immediately afterwards.
        </li>
        <div class='medium-6 medium-centered'>
          <img class='screenshot' src='http://playadj.io/non_digest_assets/screenshot_01.png' alt='Gameplay Screenshot'>
        </div>
        <li>
          On the "Cards Selection" screen, a deck of 24 random cards will be available to play. Turn order will be automatically assigned to each of you. You'll know if it's your turn already if you see the "Your turn" message at the very top, just right above the cards. If you do not see it, then it is currently someone else's turn.
        </li>
        <li>
          If it's your turn, decide wisely and click any of the four back-facing cards. By clicking so, the timer immediately starts to tick.
          <ul>
            <li>The <strong>"Bomb"</strong> icon means that the time-limit is 15 seconds, half of the normal 30 seconds.</li>
            <li>The <strong>"Question"</strong> icon means that the card can be ANY category. This card therefore is a lot harder to guess, but is why it has +2 extra stars count than its normal supposed value</li>
            <li>The <strong>"Stars"</strong> represent the 'unpopularity' of the card (as evaluated by Google Trends: 0-33 = 3 stars; 34-66 = 2 stars; 67-100 = 1 star). Each star gives +1 point to your score. Therefore, if you managed to guess a 3-star card, then your team will get +3 points.</li>
          </ul>
        </li>
        <li>
          As the timer ticks, you should describe the card through adjectives, AND, and OR only. No nouns and verbs allowed! XD Example... "Animal: small AND black OR white AND furry". Guess what? a cat! :D
        </li>
        <li>
          Your teammates can try to guess as much as they want within the time limit. If they didn't succeed, then the other teams each have just one chance to guess the card. Should everyone guessed incorrectly, then no points shall be given.
        </li>
        <li>
          After all cards have been used up, the highest scoring team will be the winner! That's just about it! :) Enjoy!
        </li>
      </ol>
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

  #game-play {
    background-color: $page-base-background-color;
    overflow-y: auto;

    .screenshot {
      width: 100%;
      margin: 1rem;
    }
  }
</style>
