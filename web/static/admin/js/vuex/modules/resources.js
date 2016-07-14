import {ACTIVE_RESOURCE, 
        UPDATE_AR_FIELD,
        SET_AR_API, 
        RECEIVE_ALL,
        RECEIVE_ONE,
        CLEAR_ALL,
        UPDATE_RESOURCE,
        SET_CURRENT_RESOURCES,
        REMOVE_RESOURCE} from "../mutation_types"
import Vue from "vue"

const state = {
  active_resource: null,
  current_resources: null,
  api: null,
  items: {},
  last_changes: {} // {id, timestamp}
}

const mutations = {
  [ACTIVE_RESOURCE]: (state, r) => {
    state.active_resource = r
  },
  [RECEIVE_ALL]: (state, rs) => {
    rs.forEach((r) => {
      if (!state.items[state.current_resources]) {
        Vue.set(state.items, state.current_resources, {})
      }
      add_resource(state, r)
    })
  },
  [RECEIVE_ONE]: (state, r) => {
    add_resource(state, r)
  },
  [CLEAR_ALL]: (state) => {
    state.items = {}
  },
  [UPDATE_AR_FIELD]: (state, {field, new_value}) => {
    state.active_resource[field] = new_value
    commit_changes(state, state.active_resource)
  },
  [SET_AR_API]: (state, api) => {
    state.api = api
  },
  [UPDATE_RESOURCE]: (state, key, r) => {
    Vue.set(state.items[state.current_resources], key, r) 
    commit_changes(state, r, r.updated_at)
  },
  [REMOVE_RESOURCE]: (state, key) => {
    Vue.delete(state.items[state.current_resources], key)
  },
  [SET_CURRENT_RESOURCES]: (state, resources) => {
    state.current_resources = resources
  }
}

export default {
  state,
  mutations
}

function add_resource(state, r) {
  if (state.current_resources) {
    Vue.set(state.items[state.current_resources], r.id, r)
    commit_changes(state, r, r.updated_at)
  }
}
function commit_changes(state, r, t) {
  let resource = state.current_resources
  t = (t ? new Date(t) : new Date()).getTime()
  Vue.set(state.last_changes, r.id, t)
}
