<template>
  <div class='small-6 columns'>
    {{ card.name }}
  </div>
</template>

<script>
export default {
  props: {
    card: {
      type: Object,
      required: true
    }
  }
}
</script>

<style lang='scss' scoped>
</style>
