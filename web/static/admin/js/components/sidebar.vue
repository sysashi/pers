<template>
<div class="sidebar">
  <div class="top-bar">
    <h3> Pers.Dashboard </h3>
  </div>
  <div class="content">
    <h4 class="category"> Resources </h4>
    <div v-for="entry in menu" class="block menu-block" >
        <ul>
          <li v-for="action in entry.actions" v-link-active> 
            <a v-link="{ path: action.link }">
              <h5>
                {{ entry.name }}
              </h5>
            </a>
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
@custom-media --only-medium-screen (width >= 500px) and (width <= 1200px);
.top-bar {
  background-color:#f3ccda;
  color: #52544d;
}
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
    @media(--only-medium-screen) {
      flex: 0 0 60px;
      & .top-bar h3 {
        display: none;
      }
      & .top-bar:after {
        content: "D";
        font-size: 32px;
        font-weight: bold;
      }
      & .content > .category {
        display: none;
      }
      & .content {
        padding: 5px;
      }
    }
}
.content {
  & ul {
    list-style: none;
    text-align: left;
    margin: 0;
    padding: 0 0 0 10px;
    & li {
      border-bottom: 2px solid #EEE;
      margin-right: -20px;
    }
    & li.v-link-active {
      border-bottom: 2px solid rgba(100, 2, 255, 0.3);
    }
  }
  & h5 {
    display: inline-block;
    padding: 5px;
    margin: 0;
    text-transform: capitalize;
    text-align: left;
  }
  & .category {
  }
  & .menu-block {
    margin-top: 20px;
  }
  & a {
    display: block;
    text-decoration: none;
  }
  @media(--only-medium-screen) {
    & a {
      text-align: center;
    }
    & ul {
      padding: 0;
    }
    & ul li {
      margin: 0;
    }
  }
}
</style>
