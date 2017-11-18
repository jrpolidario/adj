<template>
  <Card v-if='game && game.attributes.is_started' v-for='card in cards' :card='card'/>
</template>

<script>
  import Card from './cards/Card'
</script>

<style lang='scss' scoped>
</style>
