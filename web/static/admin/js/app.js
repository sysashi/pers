import Vue from "vue"
import VueRouter from "vue-router"
import VueResource from "vue-resource"
import routes from "./routes"
import Dashboard from "./components/dashboard"

Vue.use(VueRouter)
Vue.use(VueResource)

Vue.http.options.root = "/admin/api"

const environment = process.env.NODE_ENV;
const dev = "development"

Vue.config.debug = (environment === dev)
Vue.config.devtools = (environment === dev)

let router = new VueRouter({})
router.map(routes)

router.start(Dashboard, "#dashboard")

