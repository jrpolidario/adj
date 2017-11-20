<template>
  <div id='player' class='full-height'>
    <Logo/>
    <CurrentPlayer/>
  </div>
</template>

<script>
  import Logo from './player/Logo'
  import CurrentPlayer from './player/CurrentPlayer'

  export default {
    components: { Logo, CurrentPlayer }
  }
</script>

<style lang='scss' scoped>
  @import 'app/assets/stylesheets/imports/variables';

  #player {
    background-color: darken($page-base-background-color, 10);
  }
</style>
