<template>
  <div id='player' class='full-height'>
    <Logo/>
    <CurrentPlayer/>
    <CurrentGame/>
  </div>
</template>

<script>
  import Logo from './player/Logo'
  import CurrentPlayer from './player/CurrentPlayer'
  import CurrentGame from './player/CurrentGame'

  export default {
    components: { Logo, CurrentPlayer, CurrentGame }
  }
</script>

<style lang='scss' scoped>
  @import 'app/assets/stylesheets/imports/variables';

  #player {
    background-color: darken($page-base-background-color, 10);
  }
</style>
