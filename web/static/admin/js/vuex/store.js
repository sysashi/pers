import createLogger from 'vuex/logger'
import Vuex from "vuex"
import Vue from "vue"
import resources from "./modules/resources"
import notifications from "./modules/notifications"

Vue.use(Vuex)



export default new Vuex.Store({
  strict: true,
  modules: {
    resources,
    notifications
  }
//  ,
//  plugins: process.env.NODE_ENV !== 'production'
//  ? [createLogger()]
//  : []
})
