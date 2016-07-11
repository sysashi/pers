<template>
  <div class="editor">
    <div class="top-bar">
      <div class="resource-actions actions" v-if="current_resource">
          <button class="save" 
          v-on:click="save_current"
          v-if="is_new()"
          >Save</button>
          <button class="save"
          v-on:click="save_current"
          v-else
          >Update</button>
        <button class="danger" v-on:click="delte_current">Delete</button>
      </div>
    </div>
    <div class="content">
      <div class="resource-fields" v-if="current_resource">
        <div class="field id non-editable" v-if="is_in('id', fields)">
          <label> id </label> <span> {{ current_resource.id }} </span>
        </div>
        <div class="field title editable" v-if="is_in('title', fields)">
          <label> Title </label>
          <input v-model="current_resource.title">
        </div>
        <div class="field link editable" v-if="is_in('link', fields)">
          <label> Link </label>
          <input v-model="current_resource.link">
        </div>
        <div class="field published non-editable"
          v-if="current_resource.published">
          <label> Published at </label>
          <span> {{ current_resource.published_at }} </span>
          </div>
          <div v-else class="field"> Not published yet </div>
        </div>
        <div class="editor-wrapper">
          <input type="textarea" id="markdown-editor">
        </div>
      </div>
</template>

<script>
import { notify } from "../vuex/actions"
import SimpleMDE from "simplemde"

export default {
		vuex: {
			actions: {
				notify
			}
		},
		ready() {
      let simplemde = new SimpleMDE({ 
        element: document.getElementById("markdown-editor") 
      });
      this.editor = simplemde
		},
    props: {
      current_resource: Object,
      resource: Object,
      r_name: String
    },
    data() {
      return {
        editor: null
      }
    },
    computed: {
      fields() {
        return Object.keys(this.current_resource)
      },
      is_new() {
        return current_resource.id ? true : false 
      }
    },
    methods: {
    save_current(){
      if(this.editor) {
        let md = this.editor.value() 
        this.current_resource.markdown = md 
        this.current_resource.html = this.editor.options.previewRender(md)
      }
      var se = this.r_name
      if (this.current_resource.id) {
        // update exisiting
        this.resource.update({id: this.current_resource.id},
          {[se]: this.current_resource}).then((resp) => {
          this.notify({ 
            msg: `${se} was updated successfully`,
            type: "success", 
            error: {code: resp.status, detailed: resp.statusText}
          })
        })
      } else {
        // create new
        this.resource.save({id: this.current_resource.id},
          {[se]: this.current_resource}).then((resp) => {
          this.current_resource = resp.json().data
          this.notify({ 
            msg: `${se} was created successfully`,
            type: "success", 
            timeout: 3000, 
            error: {code: resp.status, detailed: resp.statusText}
          })
        })
      }
    },
    delte_current(){
      var se = this.r_name
        this.resource.delete({id: this.current_resource.id}).then((resp) => {
          this.notify({ 
            msg: `${se} was deleted successfully`,
            type: "success", 
            timeout: 3000, 
            error: {code: resp.status, detailed: resp.statusText}
          })
        })
    },
    show_editor(resource) {
      this.current_resource = resource
      if(needs_editor(resource)) {
        if(!this.editor) {
          let simplemde = new SimpleMDE({ 
            element: document.getElementById("resource-editor") 
          });
          this.editor = simplemde
        }

        this.editor.value(resource.markdown || "")
        console.log("Loaded editor for resource:", resource)
      }
    },
    is_in(key, array) {
      return array.some(elem => key == elem)
    }
  }
}
function is_in(key, array) {
  return array.some(elem => key == elem)
}
</script>

<style lang="postcss" scoped>
.top-bar {
  background: #EDFDFF; 
}
.editor {
  & .resource-fields {
    margin-bottom: 20px;
    & .field {
      display: inline-block;
      margin-right: 10px;
      & > label {
        font-weight: bold;
        border-radius: 1px;
        margin-right: 5px;
        padding: 1px 2px;
      }
      &.editable {
        & > input {
           background: rgba(58, 238, 110, 0.1);
        }
      }
      &.ncn-editable {
        & > input {
          background: rgba(244, 127, 138, 0.7);
          color: #FFF;
        }
      }
      & > input {
        padding: 5px;
        line-height: 18px;
        border-radius: 3px;
        border: 1px solid var(--color-silver);
        font-family: "Consolas", sans-serif;
        font-size: 18px;
      }

      /* specific */
      &.title > input {
        min-width: 400px;
      }
    }
  }
}
#resource-editor {
  display: none;
}
</style>

