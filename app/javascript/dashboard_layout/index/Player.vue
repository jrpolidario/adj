<template>
  <div id='player' class='full-height'>
    <Logo/>
    <CurrentPlayer/>
    <PageMenu/>
    <Links/>
  </div>
</template>

<script>
  import Logo from './player/Logo'
  import CurrentPlayer from './player/CurrentPlayer'
  import PageMenu from './player/PageMenu'
  import Links from './player/Links'

  export default {
    components: { Logo, CurrentPlayer, PageMenu, Links }
  }
</script>

<style lang='scss' scoped>
  @import 'app/assets/stylesheets/imports/variables';

  #player {
    background-color: darken($page-base-background-color, 10);
    position: relative;
  }
</style>
