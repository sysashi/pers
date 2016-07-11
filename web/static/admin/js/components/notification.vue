<template>
  <div class="notification" v-bind:class="type">
      <div class="msg">
        <span>{{ notification.msg }}</span>
      </div>
      <div class="meta">
        <div class="code" v-show="notification.error.code">
          <span> [code: {{notification.error.code}}] </span>
        </div>
      </div>
      <div class="close" v-on:click="close">
      </div>
    </div>
</template>

<script>
export default {
  methods: {
    close() {
      console.log("closeme!")
    }
  },
  computed: {
    type() {
      return {
        [this.notification.type || "normal"]: true
      }
    }
  },
  props: {
    notification: Object
  }
}
export const new_notification = (msg, type, opts) => {
  msg = msg ? msg === "" : "no msg set"
  timeout = opts.timeout || 600
  let error = {code: opts.code, detailed: ""} 
  return {
    msg,
    type,
    timeout,
    error
  }
}
</script>

<style lang="postcss" scoped>
.notification {
    display: flex;
    position: fixed;
    width: 100%;
    height: 60px;
    align-items: center;
    background: rgba(55, 178, 98, 0.65);
    & .msg {
        flex: 3;
        text-align: right;
        color: #FFF;
        font-size: 24px;
    }
    & .meta {
        flex: 1 1 250px;
        text-align: center;
        color: #FFF;
        font-size: 32px;
    }
    & .close {
        padding: 10px 10px 10px 20px;
        font-weight: bold;
        color: #FFF;
        flex: 0 0 40px;
        font-size: 18px;
        &::before {
            content: "✖";
        }
        &:hover {
            cursor: pointer;
        }
    }
}
.notification.error {
    background: rgba(231, 77, 43, 0.65);
}
</style>
