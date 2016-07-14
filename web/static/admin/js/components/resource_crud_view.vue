<template>
  <div class="crud-view">
    <div class="context">
      <div class="top-bar">
        <div class="actions" v-if="any">
          <button class="calm" v-on:click="new"> Add new {{ singular_entity }}</button>
        </div>
      </div>
      <div class="content">
          <resource-list-view 
            v-if="any"
            :resources="sorted_resources">
          </resource-list-view>
          <li class="center-text" v-show="!any"> 
            <button class="wide calm" v-on:click="new"> 
              Add your first {{ singular_entity }} 
            </button>
          </li>
      </div>
    </div>
    <div class="resource-editor">
      <editor 
        v-if="active_resource",
        :r_name="singular_entity",
        :current_resource="active_resource">
      </editor>
  </div>
</div>
</template>

<script>
import { set_current_resources, add_resource, notify, set_ar_api, set_active, fetch_resources } from "../vuex/actions"
import { New_notification } from "./notification"
import ResourceListView from "./resources_list"
import Editor from "./editor"
import SimpleMDE from "simplemde"

export default {
  name: "ResourceCrudView",
  vuex: {
    getters: {
      any(state) {
        return state.resources.items
      },
      active_resource: (state) => {
        return state.resources.active_resource
      },
      resources: (state) => {
        return state.resources.items
      },
      current_resources: (state) => {
        return state.resources.current_resources
      }
    },
    actions: {
      notify,
      set_ar_api,
      set_current_resources,
      set_active,
      add_resource,
      fetch_resources
    }
  },
  route: {
    data({ to }) {
      let resource = to.params.resource
      this.set_current_resources(resource)

      let api = this.$resource(`${to.params.resource}{/id}`)
      api.name = resource.slice(0, -1)

      this.set_ar_api(api)
      if (!Object.keys(this.resources).length > 0) {
        this.fetch_resources()
      }
    }
  },
  components: {
    ResourceListView,
    Editor
  },
  computed: {
    singular_entity() {
      // FIXME
      return this.$route.params.resource.slice(0, -1)
    },
    sorted_resources() {
      return  this.resources[this.current_resources]
      const ids = Object.keys(this.resources)
      if (ids.length > 0) {
        let by = this.sortBy || "updated_at"
        let array = []
        ids.forEach(id => array.push(this.resources[id]))
        array.sort((r1, r2) => {
          let d1 = new Date(r1[by]).getTime()
          let d2 = new Date(r2[by]).getTime()
          return d2 - d1 
        })
        return array
      }
    }
  },
  methods: {
    new() {
      let new_resource = wrap_raw_resource(editable_r)
      this.add_resource(new_resource)
      this.set_active(new_resource)
    }
  },
  data() {
    return {
      sortBy: null
    }
  }
}
const editable_r = {
  html: "",
  markdown: "",
  link: "",
  title: "",
  published: null,
}
function wrap_raw_resource(r) {
  let o = Object.assign({}, editable_r)
  o = Object.assign(o, r)
  if (r.published_at) { 
    o.published = true 
    o.published_at = new Date(r.published_at)
    .toDateString()
  }
  o.id = `new${new Date().getTime()}`
  return o
}
</script>

<style lang="postcss" scoped>
  .top-bar {
    background: #EDFDFF; 
  }
  .content li {
    list-style: none;
  }
</style>
