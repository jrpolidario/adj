<template>
  <ul id='menu'>
    <router-link :to='{ name: "gameplayPath" }' class='menu-link'>
      <li>How to play?</li>
    </router-link>
    <router-link :to='{ name: "aboutPath" }' class='menu-link'>
      <li>About</li>
    </router-link>
  </ul>
</template>

<script>
  export default {

  }
</script>

<style lang='scss' scoped>
  #menu {
    border-top: 1px solid rgba(#eee, 0.2);
    padding-top: 2rem;
    margin-top: 2rem;
    list-style: none;

    .menu-link {
      color: white;
      font-size: 1.2em;

      li:hover {
        opacity: 0.9;
        color: #efe;
        text-shadow: 0 0 0.2em rgba(yellow, 0.8);
      }
    }
  }
</style>
