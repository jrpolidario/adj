<template>
  <VueFlash :types='flash.types' :timeout='flash.timeout'/>
</template>

<script>
  import Vue from 'vue'
  import VueFlash from 'vue-flash'

  window.events = new Vue()

  window.flash = function(message, type) {
    window.events.$emit('flash', message, type)
  }

  export default {
    components: { VueFlash },
    data() {
      return {
        flash: {
          types: {
            base:    'callout',
            success: 'success',
            error:   'alert',
            warning: 'warning',
            info:    'primary'
          },
          timeout: 10000
        }
      }
    }
  }
</script>

<style lang='scss'>
  .alert-wrap {
    top: 0;
    left: 0;
    right: auto;
    width: 100%;
    opacity: 0.8;
    pointer-events: none;

    .callout {
      color: white;
      margin: 0;

      &.success {
        background: #6699CC;
      }

      &.alert {
        background: #FF3C38;
      }

      &.warning {
        background: #FF8C42;
      }

      &.primary {
        background: #FFF275;
        color: #555;
      }
    }
  }
</style>
