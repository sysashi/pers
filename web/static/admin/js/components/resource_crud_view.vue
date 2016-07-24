<template>
  <div class="crud-view">
    <div class="context">
      <div class="top-bar">
        <div class="actions" v-if="any">
          <button class="calm" v-on:click="new"> Add new {{ singular }}</button>
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
      <router-view 
        v-if="active_resource" 
        :resource="active_resource">
      </router-view> 
    </div>
</div>
</template>

<script>
import * as actions from "../vuex/actions"
import { wrap_raw_resource, project, page_like } from "../resources"
import ResourceListView from "./resources_list"
import Editor from "./editor"

export default {
  name: "ResourceCrudView",
  vuex: {
    actions,
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
    }
  },
  route: {
    data({ to }) {
      let resource = to.params.resource || to.custom_param
      this.singular = resource.slice(0, -1)

      if (!this.fetched(resource) || !to.params.id) {
        this.set_current_resources(resource)
        let api = this.$resource(`${resource}{/id}`)
        api.name = resource.slice(0, -1)
        this.set_ar_api(api)
      }

      if (!this.fetched(resource)) {
        this.fetch_resources({id: to.params.id})
      }
    }
  },
  components: {
    ResourceListView,
    Editor
  },
  computed: {
    _fetched() {
      return this.resources[this.current_resources] ? true : false
    },
    sorted_resources() {
      if (this._fetched) {
        let rs = this.resources[this.current_resources]
        const ids = Object.keys(rs)
        if (ids.length > 0) {
          let by = this.sortBy || "updated_at"
          let array = []
          ids.forEach(id => array.push(rs[id]))
          array.sort((r1, r2) => {
            let d1 = new Date(r1[by]).getTime()
            let d2 = new Date(r2[by]).getTime()
            return d2 - d1 
          })
          return array
        }
      }
    }
  },
  methods: {
    new() {
      let proto = classify_by_name(this.current_resources)
      let new_resource = wrap_raw_resource({}, proto, true)
      console.log(new_resource)
      this.add_resource(new_resource)
      this.set_active(new_resource)
      this.$router.go({name: new_resource.editor, 
                      params: {id: new_resource.id}})  
    },
    fetched(rs) {
      return this.resources[rs] ? true : false
    }
  },
  data() {
    return {
      sortBy: "published_at",
      singular: null
    }
  }
}
function classify_by_name(rsn) {
  let note_like = ["notes", "pages"]
  let project_like = ["projects"]

  if (note_like.some(n => rsn === n)) {
    return page_like
  } else if (project_like.some(n => rsn === n)) {
    return project
  }
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
