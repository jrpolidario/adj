<template>
  <ul id='links'>
    <a href='https://www.facebook.com/playadj.io/' target='_blank' rel='nofollow'><li><i class='fa fa-facebook' aria-hidden='true'></i></li></a>
    <a href='https://github.com/jrpolidario/adj' target='_blank' rel='nofollow'><li><i class='fa fa-github-alt' aria-hidden='true'></i></li></a>
    <a data-open='share-modal' target='_blank' rel='nofollow'><li><i class='fa fa-share-alt' aria-hidden='true'></i></li></a>
    <div id='share-modal' class='reveal' ref='shareModal' data-reveal>
      <p>Share on...</p>
      <div class="addthis_inline_share_toolbox"></div>
      <button class='close-button' data-close aria-label='Close modal' type='button'>
        <span aria-hidden='true'>&times;</span>
      </button>
    </div>
  </ul>
</template>

<script>
  export default {
    mounted() {
      $(this.$refs.shareModal).foundation()
    }
  }
</script>

<style lang='scss' scoped>
  @import 'app/assets/stylesheets/imports/variables';

  #links {
    position: absolute;
    bottom: 0;
    left: 0;
    list-style: none;

    a {
      display: inline-block;
      margin-right: 1rem;

      li {
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
