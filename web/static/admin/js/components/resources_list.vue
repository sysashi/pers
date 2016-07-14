<template>
  <div class="r-list">
    <ol>
      <resource 
        v-for="resource in resources | orderBy 'published_at'" 
        track-by="id"
        @click="mark_active(resource)"
        :active="is_active(resource)"
        :resource="resource"
       >
      </resource>
    </ol>
  </div>
</template>

<script>
import Resource from "./resource"

export default {
  vuex: {
    actions: {
      mark_active: ({dispatch}, r) => {
        dispatch("ACTIVE_RESOURCE", r)
      }
    },
    getters: {
      active: (state) => {
        return state.resources.active_resource
      }
    }
  },
  methods: {
    is_active(r) {
      return r == this.active
    }
  },
  components: {
    Resource
  },
  props: ['resources']
}
</script>

<style lang="postcss" scoped>
.r-list
ol {
   overflow-y: auto;
   list-style: none; 
   padding: 0;
   margin: 0;
}
.r-list
ol
li {
  margin-bottom: 20px;
  border-bottom: 2px dashed #DDDDDD;
  &:hover, &.active {
    border-color: rgba(100, 100, 222, 0.7);
    cursor: pointer;
  }
}
</style>

