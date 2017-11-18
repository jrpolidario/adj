<template>
  <span>
    <h3>{{ gamesPlayer.player().name() }}</h3>
  </span>
</template>

<script>
  export default {
    props: {
      gamesPlayer: {
        type: Object,
        required: true
      }
    }
  }
</script>

<style lang='scss' scoped>
</style>
