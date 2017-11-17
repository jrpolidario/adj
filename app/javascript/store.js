import Vue from 'vue'
import Vuex from 'vuex'
import store2 from 'store2'

Vue.use(Vuex)

const state = {
  currentPlayer: null,
  currentGame: null,
  records: {
    // this is programatically set, see created() inside application.js
  }
}

const mutations = {
  setState: (state, payload) => {
    Object.keys(payload).forEach((key, index) => {
      const value = payload[key]
      state[key] = value

      // if this particular "state" is a LiveRecord object, we need to only pass the `attributes`
      // because JSON.stringify won't work for this type of object
      let storageValue
      if (value && value.constructor.name == 'Model' && value.modelName() != undefined) {
        storageValue = value.attributes
        storageValue._isLiveRecordObject = true
        storageValue._modelName = value.modelName()
      }
      else
        storageValue = value
      store2.namespace('state').set(key, storageValue)
    })
  },
  setRecord: (state, payload) => {
    Object.keys(payload).forEach((key, index) => {
      const record = payload[key]
      Vue.set(state.records[key], record.id(), record)
    })
  },
  unsetRecord: (state, payload) => {
    Object.keys(payload).forEach((key, index) => {
      const record = payload[key]
      Vue.delete(state.records[key], record.id())
    })
  },
  setRecordAttributes: (state, payload) => {
    const record = payload.record
    const attributes = payload.attributes

    Object.keys(attributes).forEach((key, index) => {
      const attributeName = key
      const attributeValue = attributes[attributeName]

      Vue.set(state.records[record.modelName()][record.id()].attributes, attributeName, attributeValue)
    })
  }
}

const actions = {
  preloadLiveRecords(context, payload) {
    const vue = payload.vue
    const recordIds = payload.recordIds

    let totalExpectedPreloadedRecords = 0
    let preloadedRecordsCounter = 0

    Object.keys(recordIds).forEach((key, index) => {
      const modelName = key
      const Model = LiveRecord.Model.all[modelName]
      const modelRecordIds = recordIds[key]

      modelRecordIds.forEach((recordId) => {
        // if not yet in store, create
        if (Model.all[recordId] == undefined) {
          const record = new Model({id: recordId})
          const callbackToBeDestroyed = record.addCallback('after:create', function() {
            preloadedRecordsCounter++

            // if this is the last record that has been preloaded
            if (preloadedRecordsCounter == totalExpectedPreloadedRecords) {
              vue.afterPreload.call(vue)
            }
          })
          vue.callbacksToBeDestroyed.push(callbackToBeDestroyed)
          record.create({reload: true})
        }
        else
          preloadedRecordsCounter++

        totalExpectedPreloadedRecords++
      })

      // if this is the last record that has been preloaded
      if (preloadedRecordsCounter == totalExpectedPreloadedRecords) {
        vue.afterPreload.call(vue)
      }
    })
  },
  cleanup(context, payload) {
    const vue = payload.vue

    vue.subscriptionsToBeDestroyed.forEach((subscriptionToBeDestroyed) => {
      const model = subscriptionToBeDestroyed[0]
      const subscription = subscriptionToBeDestroyed[1]
      model.unsubscribe(subscription)
    })
    vue.subscriptionsToBeDestroyed = []

    vue.callbacksToBeDestroyed.forEach((callbackToBeDestroyed) => {
      const record = callbackToBeDestroyed[0]
      const callback = callbackToBeDestroyed[1]
      record.removeCallback('after:destroy', callback)
    })
    vue.callbacksToBeDestroyed = []
  },
}

const getters = {
  getState: (state) => (key) => {
    if (state[key])
      return state[key]
  },
  getRecord: (state) => (modelName, recordId) => {
    if (typeof modelName != 'string')
      throw new Error('Expected `modelName` to be a string, but is ' + typeof modelName)
    if (typeof recordId != 'string' && typeof recordId != 'number')
      throw new Error('Expected `recordId` to be a string/number, but is ' + typeof recordId)

    return state.records[modelName][recordId]
  }
}

export default new Vuex.Store({
  state,
  getters,
  actions,
  mutations
})
