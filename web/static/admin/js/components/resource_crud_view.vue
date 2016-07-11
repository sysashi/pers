<template>
  <div class="crud-view">
  <div class="context">
    <div class="top-bar">
      <div class="actions" v-if="any">
        <button class="calm" v-on:click="new"> Add new {{ singular_entity }}</button>
      </div>
    </div>
    <div class="content">
      <ol>
        <resource 
          v-if="any"
          v-for="resource in resources" 
          v-on:click="make_active(resource)"
          :resource="resource"
          :is_active="is_active(resource)"
          >
        </resource>
        <li class="center-text" v-show="!any"> 
          <button class="wide calm" v-on:click="new"> 
            Add your first {{ singular_entity }} 
          </button>
        </li>
      </ol>
    </div>
  </div>
  <div class="resource-editor">
    <editor 
      v-show="current_resource",
      :resource="resource",
      :r_name="singular_entity",
      :current_resource="current_resource">
    </editor>
</div>
</div>
</template>

<script>
import { notify } from "../vuex/actions"
import { New_notification } from "./notification"
import Resource from "./resource"
import Editor from "./editor"
import SimpleMDE from "simplemde"
export default {
  name: "ResourceCrudView",
  vuex: {
    actions: {
      notify
    }
  },
  route: {
    data({ to }) {
      let r = to.params.resource
      let resource = this.$resource(`${r}{/id}`)
      this.resource = resource

      return resource.get().then((resp) => {
        let wrapped = resp.json().data.map((r) => {
          return wrap_raw_resource(r)
        })
        return {
          resources: wrapped,
          current_resource: null
        }
      })
    }
  },
  components: {
    Resource,
    Editor
  },
  computed: {
    any() {
      return this.resources.length > 0
    },
    singular_entity() {
      // FIXME
      return this.$route.params.resource.slice(0, -1)
    }
  },
  methods: {
    make_active(r) {
      this.current_resource = r
    },
    is_active(r) {
      return this.current_resource === r
    },
    new() {
      let new_resource = editable_r
      this.resources.unshift(new_resource)
      this.current_resource = new_resource
    }
  },
  data() {
    return {
      resources: [],
      resource: null,
      r_name: "",
      current_resource: null,
			editor: null
    }
  },
  ready() {
    this.r_name = this.$route.params.resource
  }
}
let editable_r = {
  html: "",
  markdown: "",
  link: "",
  title: "",
  editable: true,
  published: false,
  published_at: "-",
}
function wrap_raw_resource(r) {
  let o = Object.assign({}, editable_r)
  o = Object.assign(o, r)
  if (r.published_at) { 
    o.published = true 
    o.published_at = new Date(r.published_at)
    .toDateString()
  }
  if (r.html || r.markdown) { o.editable = true }
  return o
}
</script>

<style lang="postcss" scoped>
  .top-bar {
    background: #EDFDFF; 
  }
  .content
  ol {
	 overflow-y: auto;
   list-style: none; 
   padding: 0;
   margin: 0;
  }
</style>
