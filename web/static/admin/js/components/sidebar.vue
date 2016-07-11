<template>
<div class="sidebar">
  <div class="top-bar">
    <h3> Pers.Dashboard </h3>
  </div>
  <div class="content">
    <div v-for="entry in menu" class="block menu-block">
        <h5>{{ entry.name }}</h5>
        <ul>
          <li v-for="action in entry.actions"> 
    <a v-link="{ path: action.link }">{{ action.name }}</a>
          </li>
        </ul>
    </div>
  </div>
</div>
</template>

<script>
  import {menu} from "../resources"
  export default {
    data() {
      return {
        menu: menu
      }
    }
  }
</script>

<style lang="postcss" scoped>
.top-bar {
  background-color:#f3ccda;
  color: #52544d;
}
</style>
