<template>
<h1>
  <div class='title-outer-container width-proportional-to-height-container'>
    <div class='width-proportional-to-height-content'>
      <div class='title-inner-container'>
        <span class='title-a'>A</span><span class='title-d'>D</span><span class='title-j'>J</span>
      </div>
    </div>
  </div>
</h1>
</template>

<style lang='scss' scoped>
h1 {
  color: white;
  font-size: 3em;
  text-shadow: 0 0.02em 0.02em rgba(0,0,0,0.6);

  .title-outer-container {
    $title-background-color: #105D2A;
    background: $title-background-color;
    border: 0.2em solid darken($title-background-color, 2);
    border-radius: 50%;
    width: 2em;
    left: 50%;
    transform: translateX(-50%);

    .title-inner-container {
      position: absolute;
      left: 50%;
      top: 50%;
      transform: translate(-50%, -50%);

      .title-a {
        // golden ration: 38.1966
        color: lighten(#C60000, 38.1966);
        font-size: 0.75em;
        vertical-align: middle;
      }

      .title-d {
        color: lighten(#00DA00, 38.1966);
        vertical-align: middle;
      }

      .title-j {
        color: lighten(#C6C600, 38.1966);
        font-size: 0.75em;
        vertical-align: middle;
      }
    }
  }
}
</style>
