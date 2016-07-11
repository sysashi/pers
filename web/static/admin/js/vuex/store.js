import Vuex from "vuex"
import Vue from "vue"
Vue.use(Vuex)

const state = {
  notifications: []
}

const mutations = {
  PUT_NOTIFICATION(state, n) {
    state.notifications.push(n)
  },
  REMOVE_NOTIFICATION(state, n) {
    state.notifications.$remove(n)
  },
  CLEAR_ALL(state) {
    state.notifications = []
  }
}

// const error_notifyer = store => {
//   store.subscribe((mutation, state) => {
//     if(mutation.type === "ADD_ERROR") {
//       let error = mutation.payload[0]
//       console.log(error)
//     }
//   })
// }

export default new Vuex.Store({
  strict: true,
  state,
  mutations
})
