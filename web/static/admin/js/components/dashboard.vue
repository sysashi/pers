<template>
  <div class="dashboard" id="dashboard">
    <notification
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
  import UtilityBar from "./utility_bar"
  import store from "../vuex/store"
  import { remove_notification } from "../vuex/actions"

  export default {
    store,
    components: {
      Sidebar,
      UtilityBar,
      Notification
    },
    vuex: {
      actions: {
        remove_notification
      },
      getters: {
        notifications(state) {
          return state.notifications
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
    flex: 0 0 400px;
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

.dashboard
.sidebar {
    height: 100%;
    & .block {
        lost-column: 1 0 0;
        & .pad {
            padding: 0 40px 10px 40px;
        }
    }
    & h1, & h2, & h3, & h4, & h5 {
        margin: 5px 0;
    }
}
.dashboard
.sidebar
.block {
    & > *:nth-child(1) {
        margin-top: 0;
        padding-top: 0;
    }
    border-bottom: 1px dashed #fff;
}
.dashboard
.sidebar
.menu-block {
    & ul {
        padding-bottom: 0;
        margin-bottom: 0;
    }
}
</style>
