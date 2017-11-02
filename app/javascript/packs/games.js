import Vue from 'vue/dist/vue.common'
import NewGame from '../games/new';

// Basic vue instance
new Vue({
  el: '#games',
  template: '<NewGame/>',
  components: { NewGame }
});
