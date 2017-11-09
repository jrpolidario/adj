<template>
  <div id='new-game' class='full-height'>
    <Logo/>
  </div>
</template>

<script>
import Logo from './new_game/Logo'

export default {
  components: { Logo }
}
</script>

<style lang='scss' scoped>
@import '../../packs/games';

#new-game {
  background: darken(#7CBB91, 10);
}
</style>
