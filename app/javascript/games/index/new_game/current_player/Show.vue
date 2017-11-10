<template>
  <div id='new-player'>
    <h2>{{ currentPlayer.name }}</h2>
  </div>
</template>

<script>
  import currentPlayer from 'globals.js'

  export default {
    computed: {
      currentPlayer
    }
  }
</script>

<style lang='scss' scoped>
</style>
