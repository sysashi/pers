<template>
  <div class="editor">
    <div class="top-bar">
      <div class="resource-actions actions" v-if="current_resource">
        <button class="save" v-on:click="save" v-if="is_new">Save</button>
        <button class="save" v-on:click="update" v-else>Update</button>
        <button class="danger" v-on:click="delete">Delete</button>
      </div>
    </div>
    <div class="content">
      <div class="resource-fields">
        <div class="field title editable">
          <label> Title </label>
          <input :value="current_resource.title" @input="update_title">
        </div>
        <div class="field link editable">
          <label> Link </label>
          <input :value="current_resource.link" @input="update_link">
        </div>
        <div class="field published non-editable"
          v-if="current_resource.published && current_resource.published_at">
          <label> Published at </label>
          <span> {{ current_resource.published_at }} </span>
          </div>
          <!-- <div v-else class="field"> Not published yet </div> -->
          <label> Publish? </label>
          <input type="checkbox" v-model="to_publish">
        </div>
        <div class="editor-wrapper">
          <input type="textarea" id="markdown-editor">
          {{ current_resource.markdown }}
        </div>
      </div>
</template>

<script>
import { notify, update_ar_field, save_ar, update_ar, delete_ar } from "../vuex/actions"
import SimpleMDE from "simplemde"

export default {
		vuex: {
			actions: {
        notify,
        update_ar_field,
        save_ar,
        update_ar,
        delete_ar
			},
      getters: {
        current_resource: (state) => {
          return state.resources.active_resource
        }
      }
		},
		ready() {
      let simplemde = new SimpleMDE({ 
        element: document.getElementById("markdown-editor") 
      });
      let it = this

      simplemde.codemirror.on("focus", function(){
         console.log(simplemde.value(it.current_resource.markdown));
      });

      this.editor = simplemde
		},
    props: {
    },
    data() {
      return {
        editor: null
      }
    },
    computed: {
      is_new() {
        return this.current_resource.inserted_at ? false : true
      },
      to_publish: {
        get() {
          return this.current_resource.published 
        },
        set(val) {
          this.update_ar_field("published", val)
          if (!val) {this.update_ar_field("published_at", null)}
        }
      }
    },
    methods: {
      sync_editor() {
        if(this.editor) {
          let md = this.editor.value() 
          this.update_ar_field("markdown", md)
          this.update_ar_field("html", this.editor.options.previewRender(md))
        }
      },
      update_title(e) {
        this.update_ar_field("title", e.target.value)
      },
      update_link(e) {
        this.update_ar_field("link", e.target.value)
      },
      save(){
        this.sync_editor()
        this.save_ar()
      },
      update() {
        this.sync_editor()
        this.update_ar()
      },
      delete(){
        this.delete_ar()
      }
    }
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

