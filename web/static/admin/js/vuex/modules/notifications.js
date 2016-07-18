import { PUT_NOTIFICATION, 
  REMOVE_NOTIFICATION, 
  CLEAR_ALL } from "../mutation_types"

const state = {
  all: []
}

const mutations = {
  [PUT_NOTIFICATION]: (state, n) =>  {
    state.all.push(n)
  },
  [REMOVE_NOTIFICATION]: (state, n) => {
    state.all.$remove(n)
  },
  [CLEAR_ALL]: (state) => {
    state.all = []
  }
}

export default {
  state,
  mutations
}
