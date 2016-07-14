<template>
<li v-bind:class="{ 'active': active }">
  <div class="r-preview">
    <div class="title">
      <strong> Title: </strong> <span v-if="resource.title"> {{
        resource.title }}</span>
      <span class="mute" v-else><i>(empty)</i></span>
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
    <div class="link">
      <span> Link: </span>
      <span class="link" v-if="resource.link"> 
        {{ resource.link }} 
      </span>
      <span class="mute" v-else><i>(empty)</i></span>
    </div>
  </div>
</li>
</template>

<script>
  export default {
    vuex: {
      getters: {
        last_changes: (state) => {
          return state.resources.last_changes
        }
      }
    },
    computed: {
      any_changes() {
        let server_t = new Date(this.resource.updated_at).getTime()
        return this.last_changes[this.resource.id] > server_t
      }
    },
    props: [
      "resource", "active"
    ]
  }
</script>

<style lang="postcss" scoped>
  .r-preview {
    margin-bottom: 5px;
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
