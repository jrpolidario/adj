/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> (and
// <%= stylesheet_pack_tag 'hello_vue' %> if you set extractStyles to true
// in config/webpack/loaders/vue.js) to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

import 'babel-polyfill'
import Vue from 'vue'
import VueRouter from 'vue-router'
import Application from './Application.vue'
import ShowGame from '../games/Show'
import AllGames from '../games/Index'
import NotFound from '../errors/NotFound'
import store from 'store'

Vue.use(VueRouter)

document.addEventListener('DOMContentLoaded', () => {

  function routeWithoutFormat(route) {
    return route.toString().replace('(.:format)', '')
  }

  const router = new VueRouter({
    mode: 'history',
    base: __dirname,
    routes: [
      { path: routeWithoutFormat(Routes.root_path), component: AllGames },
      { path: routeWithoutFormat(Routes.game_path), component: ShowGame },
      { path: "*", component: NotFound }
    ]
  })

  document.body.appendChild(document.createElement('Application'))

  const VueApp = new Vue({
    router,
    store,
    render: h => h(Application),
    methods: {
      configureWithLiveRecordStore() {
        // now we make our LiveRecord records-store reactive & compatible with our vuex store.js
        const self = this

        window.vw = self

        Object.keys(LiveRecord.Model.all).forEach((key,index) => {
          const model = LiveRecord.Model.all[key]

          self.$set(self.$store.state.records, key, model.all)

          model.addCallback('before:create', function() {
            const record = this
            // Vue.util.defineReactive(LiveRecord.Model.all[key].all, record.id(), record)
            // Vue.util.defineReactive(LiveRecord.Model.all[key].all[record.id()], 'attributes', record.attributes)
            self.$store.commit('setRecord', {[key]: record})
          })

          model.addCallback('before:destroy', function() {
            const record = this
            self.$store.commit('unsetRecord', {[key]: record})
          })
        })
      }
    },
    created() {
      this.configureWithLiveRecordStore()
    }
  }).$mount('Application')
})


// The above code uses Vue without the compiler, which means you cannot
// use Vue to target elements in your existing html templates. You would
// need to always use single file components.
// To be able to target elements in your existing html/erb templates,
// comment out the above code and uncomment the below
// Add <%= javascript_pack_tag 'hello_vue' %> to your layout
// Then add this markup to your html template:
//
// <div id='hello'>
//   {{message}}
//   <app></app>
// </div>


// import Vue from 'vue/dist/vue.esm'
// import App from './app.vue'
//
// document.addEventListener('DOMContentLoaded', () => {
//   const app = new Vue({
//     el: '#hello',
//     data: {
//       message: "Can you say hello?"
//     },
//     components: { App }
//   })
// })
