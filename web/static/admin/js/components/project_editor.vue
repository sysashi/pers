<template>
  <div class="editor">
    <div class="top-bar">
      <div class="resource-actions actions" v-if="resource">
        <button class="save" v-on:click="save" v-if="is_new">Save</button>
        <button class="save" v-on:click="update" v-else>Update</button>
        <button class="danger" v-on:click="delete">Delete</button>
      </div>
    </div>
    <div class="content">
      <div class="resource-fields">
        <div class="field name editable">
          <label> Name </label>
          <input :value="resource.name" @input="update_name">
        </div>
        <div class="field status editable">
          <label> Status </label>
          <input :value="resource.status" @input="update_status">
        </div>
        <div class="field desc editable">
          <label> Description </label>
          <textarea type="textarea" rows="5" cols="30" :value="resource.desc"
            @input="update_desc"></textarea>
        </div>
        <div class="field links editable">
          <label> Links <button v-on:click="add_link"> + </button></label>
          <ul>
            <li v-for="link in resource.links">
              {{ $key }}
              <input :value="link.showas" @input="update_link_key($event, $key)">:
              <input :value="link.path" @input="update_link_value($event, $key)">
            </li>
          </ul>
        </div>
        <!-- <div class="field published non-editable"
          v-if="resource.published && resource.published_at">
          <label> Published at </label>
          <span> {{ resource.published_at }} </span>
        </div> -->
          <!-- <div v-else class="field"> Not published yet </div> -->
        <!-- <div class="field publish editable">
          <label> Publish? </label>
          <input type="checkbox" v-model="to_publish">
        </div> -->
      </div>
    </div>
</template>

<script>
import * as actions from "../vuex/actions"
  export default {
    vuex: {
      actions
    },
    props: ["resource"],
    computed: {
      is_new() {
        return this.resource.inserted_at ? false : true
      }
    },
    methods: {
      update_name(e) {
        this.update_ar_field("name", e.target.value)
      },
      update_desc(e) {
        this.update_ar_field("desc", e.target.value)
      },
      update_status(e) {
        this.update_ar_field("status", e.target.value)
      },
      // FIXME
      add_link(name) {
        name = "github"
        this.update_ar_map("links", {[name]: { showas: "" , path: "" }})
      },
      update_link_key(e, key) {
        console.log(key)
        this.update_ar_map("links", `showas`, e.target.value)
      },
      update_link_value(e, key) {
        this.update_ar_map("links", `${key}.path`, e.target.value)
      },
      save(){
        this.save_ar({router: this.$router})
      },
      update() {
        this.update_ar()
      },
      delete(){
        if (this.is_new) {
          this.remove_resource(this.resource.id)
        } else {
          this.delete_ar()
        }
        this.$router.go({path: "/manage/projects"})
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
      display: block;
      margin-right: 10px;
      margin-bottom: 10px;
      & > label {
        display: inline-block;
        min-width: 10%;
        font-weight: bold;
        vertical-align: top;
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
</style>
