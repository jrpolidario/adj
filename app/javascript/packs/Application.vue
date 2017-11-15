<template>
  <section id='application' class='full-height'>
    <router-view></router-view>
    <Flash/>
  </section>
</template>

<script>
  import Flash from  './Flash'

  export default {
    components: { Flash }
  }
</script>
