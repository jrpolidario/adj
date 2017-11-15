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
      if (value.constructor.name == 'Model' && value.modelName() != undefined) {
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
}

const getters = {
  getState: (state) => (key) => {
    if (state[key])
      return state[key]
  },
  getRecord: (state) => (modelName, recordId) => {
    return state.records[modelName][recordId]
  }
}

export default new Vuex.Store({
  state,
  getters,
  actions,
  mutations
})
