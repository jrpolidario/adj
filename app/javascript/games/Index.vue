<template>
  <section id='all-games' class='row collapse full-height full-width'>
    <div class='large-3 medium-4 columns full-height'>
      <NewGame/>
    </div>
    <div class='large-6 medium-4 columns full-height'>
      <AllGames/>
    </div>
    <div class='large-3 medium-4 columns full-height'>
      <AllComments/>
    </div>
  </section>
</template>

<script>
  import NewGame from './index/NewGame'
  import AllGames from './index/AllGames'
  import AllComments from './index/AllComments'

  export default {
  	components: { NewGame, AllGames, AllComments }
  }
</script>

<style lang='scss' scoped>
  #all-games {
    color: white;

    // >>> means it affects children components
    > div.columns >>> > * {
      padding: 2rem;
    }
  }
</style>
