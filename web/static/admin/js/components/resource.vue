<template>
  <li class="r-preview" v-bind:class="{ 'active': is_active }">
  <div class="r-preview">
    <div class="title">
      <strong> Title: </strong> <span v-if="resource.title"> {{
        resource.title }}</span>
      <span v-else> no title </span>
    </div>
    <div class="link">
      <i> Link: </i> <span class="link"> {{ resource.link }} </span>
    </div>
    <div class="resource-meta">
    </div>
  </div>
</li>
</template>

<script>
  export default {
    props: {
      resource: Object,
      is_active: Boolean
    }
  }
</script>

<style lang="postcss" scoped>
  div.r-preview > div {
    margin-top: 5px;
  }
  li.r-preview {
    margin-top: 10px;
    padding-bottom: 10px;
    border-bottom: 2px dashed #DDDDDD;
    &:hover, &.active {
      border-color: rgba(100, 100, 222, 0.7);
      cursor: pointer;
    }
  }
  li.r-preview > a {
    display: block;
		font-size: 14px;
  }
  li.r-preview > a > h3 {
		margin: 0;
		padding: 0;
	}
</style>
