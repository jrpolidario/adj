/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> (and
// <%= stylesheet_pack_tag 'hello_vue' %> if you set extractStyles to true
// in config/webpack/loaders/vue.js) to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

import 'babel-polyfill'
import Vue from 'vue'
import VueRouter from 'vue-router'
import Promise from 'promise-polyfill';
import Application from './Application.vue'

import DashboardLayout from 'dashboard_layout/Index'
import GameLayout from 'game_layout/Index'

import Gameplay from 'dashboard_layout/index/Gameplay'
import About from 'dashboard_layout/index/About'
import Games from 'dashboard_layout/index/Games'
import NewGame from 'dashboard_layout/index/NewGame'
import JoinGame from 'dashboard_layout/index/JoinGame'

import NotFound from 'errors/NotFound'
import Forbidden from 'errors/Forbidden'

import store from 'store' // this is store.js
import store2 from 'store2' // this is a session/localstorage package

Vue.use(VueRouter)

// fixed: mobile virtual-keyboard messing up the height of the body, which pushes it upwards
// every time the virtual-keyboard is closed
$(function () {
  $('body').height($(document).height());
});

document.addEventListener('DOMContentLoaded', () => {

  const router = new VueRouter({
    mode: 'history',
    base: __dirname,
    routes: [
      { path: '/', component: DashboardLayout,
        children: [
          { path: '', component: Games, name: 'rootPath' },
          { path: 'gameplay', component: Gameplay, name: 'gameplayPath' },
          { path: 'about', component: About, name: 'aboutPath' },
          { path: 'games/new', component: NewGame, name: 'newGamePath' },
          { path: 'games/:game_id/games_players/new', component: JoinGame, name: 'joinGamePath' },
        ]
      },
      { path: '/games/:id', component: GameLayout, name: 'gamePath' },
      { path: "*", component: NotFound },
      { path: "/forbidden", component: Forbidden, name: 'forbiddenPath' }
    ]
  })

  document.body.appendChild(document.createElement('Application'))

  const VueApp = new Vue({
    router,
    store,
    render: h => h(Application),
    created() {
      this.configureWithLiveRecordStore()
      this.loadSession()
      this.loadStorage()
    },
    methods: {
      configureWithLiveRecordStore() {
        // now we make our LiveRecord records-store reactive & compatible with our vuex store.js
        const self = this

        Object.keys(LiveRecord.Model.all).forEach((key,index) => {
          const model = LiveRecord.Model.all[key]

          self.$set(self.$store.state.records, key, model.all)

          model.addCallback('before:create', function() {
            const record = this
            // Vue.util.defineReactive(LiveRecord.Model.all[key].all, record.id(), record)
            // Vue.util.defineReactive(LiveRecord.Model.all[key].all[record.id()], 'attributes', record.attributes)
            self.$store.commit('setRecord', {[key]: record})
          })

          model.addCallback('before:update', function() {
            const record = this
            // Vue.util.defineReactive(LiveRecord.Model.all[key].all, record.id(), record)
            // Vue.util.defineReactive(LiveRecord.Model.all[key].all[record.id()], 'attributes', record.attributes)
            // self.$store.commit('setRecordAttributes', {[key]: record})

            if (record.changes) {
              const newAttributes = []

              Object.keys(record.changes).forEach((key, index) => {
                const attribute = key
                const change = record.changes[attribute]
                const oldValue = change[0]
                const newValue = change[1]

                newAttributes[attribute] = newValue
              })

              self.$store.commit('setRecordAttributes', {
                record: record,
                attributes: newAttributes
              })
            }
          })

          model.addCallback('before:destroy', function() {
            const record = this
            self.$store.commit('unsetRecord', {[key]: record})
          })
        })
      },
      loadStorage() {
        const self = this
        // iterate over each "state", and retrieve from storage if exists
        Object.keys(this.$store.state).forEach((key, index) => {
          const storageValue = store2.namespace('state').get(key)

          if (!storageValue)
            return

          if (!storageValue._isLiveRecordObject) {
            this.$store.state[key] = storageValue
            return
          }
          else {
            // resync the record from backend
            const modelName = storageValue._modelName
            // copy attributes (which is the storageValue) only except some injected properties
            const attributes = storageValue
            delete(storageValue._modelName)
            delete(storageValue._isLiveRecordObject)

            let record = LiveRecord.Model.all[modelName][attributes.id]

            // if not yet in store
            if (!record) {
              record = new LiveRecord.Model.all[modelName](attributes)

              record.addCallback('after:update', function() {
                // if changed, update storage value
                if (this.changes && Object.keys(this.changes).length > 0) {
                  // state[key] = this
                  const newAttributes = this.attributes
                  newAttributes._isLiveRecordObject = true
                  newAttributes._modelName = this.modelName()
                  store2.namespace('state').set(key, newAttributes)
                }
              })

              record.addCallback('after:destroy', function() {
                self.$store.state[key] = null
                store2.namespace('state').remove(key)
              })

              record.create()
            }

            this.$store.state[key] = record
          }
        })
      },
      loadSession() {
        const self = this
        this.$store.dispatch('adjAjax', {
          url: Routes.me_sessions_path(),
          method: 'get',
          success: function(data) {
            const session = data
            let currentPlayer

            // we set currentPlayer from the backend session, to make sure they're in-sync
            if (session.player_id) {
              currentPlayer = LiveRecord.Model.all.Player.all[session.player_id]

              // if not yet existing in LiveRecord store, we create
              if (!currentPlayer) {
                currentPlayer = new LiveRecord.Model.all.Player({id: session.player_id})
                currentPlayer.create()
              }
            }
            else
              currentPlayer = null

            self.$store.commit('setState', { currentPlayer: currentPlayer })

            // also store _csrf_token for later AJAX requests
            if (session._csrf_token) {
              self.$store.commit('setState', { 'csrfToken': session._csrf_token })
            }
          }
        })
      }
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
