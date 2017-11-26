<template>
  <section id='dashboard-layout' class='row collapse full-height full-width'>
    <h1 class='hide'>Adj Dashboard</h1>
    <div class='large-3 medium-4 columns full-height'>
      <Player/>
    </div>
    <div class='large-6 medium-4 columns full-height'>
      <router-view></router-view>
    </div>
    <div class='large-3 medium-4 columns full-height'>
      <Comments/>
    </div>
  </section>
</template>

<script>
  import Player from './index/Player'
  import Comments from './index/Comments'

  export default {
  	components: { Player, Comments }
  }
</script>

<!-- GLOBAL STYLES FOR DASHBOARD LAYOUT -->
<style lang='scss'>
  @import 'app/assets/stylesheets/imports/variables';
  @import 'animate.css/animate.min.css';

  #dashboard-layout {
    color: white;
    background-color: lighten($page-base-background-color, 10);

    > div.columns > * {
      padding: 2rem;
    }
  }
  .button {
    border: 1px solid rgba(white, 0.25);
    background: transparent;
  }
</style>
