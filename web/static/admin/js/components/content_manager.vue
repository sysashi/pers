<template>
  <resource-crud-view></resource-crud-view>
</template>

<script>
  import ResourceCrudView from "./resource_crud_view"
  
  export default {
    name: "ContentManager",
    components: {
      "resource-crud-view": ResourceCrudView
    }
  }
</script>
