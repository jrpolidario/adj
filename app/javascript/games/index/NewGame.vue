<template>
  <div id='new-game' class='full-height'>
    <Logo/>
    <CurrentPlayer/>
  </div>
</template>

<script>
  import Logo from './new_game/Logo'
  import CurrentPlayer from './new_game/CurrentPlayer'

  export default {
    components: { Logo, CurrentPlayer }
  }
</script>

<style lang='scss' scoped>
  @import 'app/javascript/packs/games';

  #new-game {
    background-color: darken($page-base-background-color, 10);
  }
</style>
