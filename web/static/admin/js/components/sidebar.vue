<template>
<div class="sidebar">
  <div class="top-bar">
    <h2> Dashboard </h2>
  </div>
  <div class="content">
    <span class="category"> Resources </span>
    <div v-for="entry in menu" class="resources-entries" >
        <ul>
          <li v-for="action in entry.actions" v-link-active> 
            <a v-link="{ path: action.link }">
              <span class="resource-name">
                {{ entry.name }}
              </span>
            </a>
          </li>
        </ul>
    </div>

    <span class="category"> Settings </span>
    <div class="block menu-block admin-entry">
        admin
    </div>

    <div class="block menu-block bottom-block">
        <a href="/logout"> logout </a>
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
@custom-media --only-medium-screen (width >= 500px) and (width <= 1200px);
.top-bar {
  background-color:#f3ccda;
  color: #52544d;
}
.sidebar {
    height: 100%;
    & .block {
    }
}
.content {
  padding: 0;

  & .category {
      display: block;
      font-size: 18px;
      padding: 20px;
      border-bottom: 1px solid #BDC1F2;
  }

  & ul {
    list-style: none;
    text-align: left;
    margin: 0;
    padding: 0;


    & li {
        padding: 10px 25px;
        font-size: 15px;
        background: #efefff;
        border-bottom: 1px solid #BDC1F2;
    }

    & li.v-link-active {
      background: #a9aae8;
      border-bottom: 1px solid #637CA8;

      & a:before {
          content: ">";
          font-weight: bold;
      }
    }

    & .resource-name {
        display: inline-block;
        padding: 5px;
        margin: 0;
        text-transform: capitalize;
        text-align: left;
    }

    & a {
        display: block;
        text-decoration: none;
        &:active {
            color: #333;
        }
    }
  }
}
</style>
