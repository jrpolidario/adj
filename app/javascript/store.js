import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

const state = {
  currentPlayer: null
}

const mutations = {
  setCurrentPlayer: (state, player) => {
    state.currentPlayer = player
    localStorage.setItem('currentPlayerAttributes', JSON.stringify(player.attributes))
  }
}

const actions = {
}

const getters = {
  currentPlayer: (state) => {
    if (!state.currentPlayer) {
      const currentPlayerAttributes = JSON.parse(localStorage.getItem('currentPlayerAttributes'))

      if (currentPlayerAttributes) {
        let currentPlayer = LiveRecord.Model.all.Player.all[currentPlayerAttributes.id]

        // if player not yet in LiveRecord store, create it, and resync it from backend
        if (!currentPlayer) {
          currentPlayer = new LiveRecord.Model.all.Player(currentPlayerAttributes)
          currentPlayer.create({reload: true})
          currentPlayer.addCallback('after:update', function() {
            // if changed, re-set currentPlayer
            if (Object.keys(this.changes).length > 0) {
              state.currentPlayer = this
              localStorage.setItem('currentPlayerAttributes', JSON.stringify(state.currentPlayer.attributes))
            }
          })
        }

        state.currentPlayer = currentPlayer
      }
    }

    return state.currentPlayer
  }
}

export default new Vuex.Store({
  state,
  getters,
  actions,
  mutations
})
