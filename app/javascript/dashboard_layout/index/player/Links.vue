<template>
  <ul id='links'>
    <a href='https://www.facebook.com/playadj.io/' target='_blank' rel='nofollow'><li><i class='fa fa-facebook' aria-hidden='true'></i></li></a>
    <a href='https://github.com/jrpolidario/adj' target='_blank' rel='nofollow'><li><i class='fa fa-github-alt' aria-hidden='true'></i></li></a>
  </ul>
</template>

<script>
  export default {

  }
</script>

<style lang='scss' scoped>
  @import 'app/assets/stylesheets/imports/variables';

  #links {
    position: absolute;
    bottom: 0;
    left: 0;
    list-style: none;

    li {
      display: inline-block;

      margin-right: 1rem;

      border-radius: 50%;
      border: 1px solid white;
      background: white;
      width: 2rem;
      height: 2rem;

      position: relative;

      &:hover {
        opacity: 0.8;
        box-shadow: 0 0 0.4em rgba(yellow, 0.8);
      }
    }

    .fa {
      font-size: 1.5rem;
      color: darken($page-base-background-color, 10);
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
    }
  }
</style>
