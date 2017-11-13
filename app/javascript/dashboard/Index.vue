<template>
  <section id='games' class='row collapse full-height full-width'>
    <div class='large-3 medium-4 columns full-height'>
      <Player/>
    </div>
    <div class='large-6 medium-4 columns full-height'>
      <Games/>
    </div>
    <div class='large-3 medium-4 columns full-height'>
      <Comments/>
    </div>
  </section>
</template>

<script>
  import Player from './index/Player'
  import Games from './index/Games'
  import Comments from './index/Comments'

  export default {
  	components: { Player, Games, Comments }
  }
</script>

<style lang='scss' scoped>
  #games {
    color: white;

    // >>> means it affects children components
    > div.columns >>> > * {
      padding: 2rem;
    }
  }
</style>
