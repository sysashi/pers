<template>
<li v-bind:class="{ 'active': active }">
  <a
    v-link="{name: resource.editor, params: {id: resource.id}}"
    v-on:click="set_active(resource)"
    class="r-preview">

    <div class="title">
      <span v-if="resource.title">
      <strong> Title: </strong>
        {{ resource.title }}
      </span>

      <span v-if="resource.name">
      <strong> Name: </strong>
        {{ resource.name }}
      </span>

      <!-- <span class="mute" v-else><i>(empty)</i></span> -->
      <span class="state old"
        transition="fadeinout"
        v-if="any_changes">✘</span>
      <span class="state published"
        v-else
        v-if="resource.published">●</span>
      <!--
      <span class="state recent" v-if="active">✔</span>
      -->
    </div>
    <div class="link" v-if="resource.link">
      <span> Link: </span>
      <span class="link">
        {{ resource.link }}
      </span>
    </div>
    <!-- <span class="mute" v-else><i>(empty)</i></span> -->
  </a>
</li>
</template>

<script>
  export default {
    vuex: {
      getters: {
        last_changes: (state) => {
          return state.resources.last_changes[state.resources.current_resources]
        },
        current_resources: (state) => {
          return state.resources.current_resources
        }
      },
      actions: {
        set_active: ({dispatch}, r) => {
          dispatch("ACTIVE_RESOURCE", r)
        }
      }
    },
    computed: {
      any_changes() {
        let server_t = new Date(this.resource.updated_at).getTime()
        if (this.last_changes) {
          return this.last_changes[this.resource.id] > server_t
        }
      }
    },
    props: [
      "resource", "active"
    ]
  }
</script>

<style lang="postcss" scoped>
  .r-preview {
    display: block;
    margin-bottom: 5px;
    text-decoration: none;
    color: #444;
  }
  .r-preview > div {
    margin-top: 5px;
  }
  .r-preview > a {
    display: block;
		font-size: 14px;
  }
  .r-preview > a > h3 {
		margin: 0;
		padding: 0;
	}
  .r-preview span {
    overflow-wrap: break-word
  }
  .state {
    float: right;
    margin-left: 5px;
  }
  .state.published {
    color: lightgreen
  }
  .state.recent {
    color: lightgreen
  }
  .state.old {
    color: red;
  }
  .mute {
    color: #DDD;
    font-size: 90%;
  }
</style>
