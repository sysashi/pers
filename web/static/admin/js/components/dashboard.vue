<template>
  <div class="dashboard" id="dashboard">
    <notification
      transition="fadeinout"
      v-for="notification in notifications"
      @click="remove_notification(notification)",
      :notification="notification">
    </notification>
    <sidebar></sidebar>
    <router-view></router-view>
  </div>
</template>

<script>
  import Notification from "./notification"
  import Sidebar from "./sidebar"
  import store from "../vuex/store"
  import { remove_notification } from "../vuex/actions"

  export default {
    store,
    components: {
      Sidebar,
      Notification
    },
    vuex: {
      actions: {
        remove_notification
      },
      getters: {
        notifications(state) {
          return state.notifications.all
        }
      }
    },
    methods: {
      close(n) {
        remove_notification(n)
      }
    }
  }
</script>

<style lang="postcss">
*:focus {
  outline: none;
}
.dashboard {
    color: #3c4254;
    flex: 1;
    display: flex;
}
.sidebar {
    border-right: 1px solid #DDD;
    flex: 0 0 250px;
}
.context {
    border-right: 1px solid #DDD;
    flex: 1;
    max-width: 450px;
}
.wrapper {
    flex: 2;
}
.crud-view {
    flex: 1;
    display: flex;
    & .resource-editor {
        flex: 3;
    }
}
.top-bar {
    display: flex;
    border-color: #BBB;
    align-items: center;
    justify-content: flex-end;
    height: 60px;
    text-align: right;
    & > * {
        margin-right: 10px;
    }
}
.dashboard
.content {
    padding: 20px;
    max-height: calc(100vh - 100px);
    min-height: calc(100vh - 100px);
    border-right: 1px solid var(--color-silver);
    overflow-y: scroll;
}
.dashboard
.sidebar
.top-bar {
    justify-content: center;
}
.dashboard
.sidebar
.content {
    overflow-y: auto;
}
.wrapper
.content
.resource-crud-view {
    flex: 1;
    overflow-y: scroll;
    padding: 20px;
}
.wrapper
.content
.resource-editor {
    flex: 2;
    overflow-y: scroll;
    padding: 20px;
}
</style>
