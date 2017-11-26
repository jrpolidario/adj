<template>
  <div id='player' class='full-height'>
    <Logo/>
    <CurrentPlayer/>
    <Menu/>
    <Links/>
  </div>
</template>

<script>
  import Logo from './player/Logo'
  import CurrentPlayer from './player/CurrentPlayer'
  import Menu from './player/Menu'
  import Links from './player/Links'

  export default {
    components: { Logo, CurrentPlayer, Menu, Links }
  }
</script>

<style lang='scss' scoped>
  @import 'app/assets/stylesheets/imports/variables';

  #player {
    background-color: darken($page-base-background-color, 10);
    position: relative;
  }
</style>
