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
    font-weight: bold;
    text-shadow: 0 0 0.05em rgba(0,0,0,0.4);

    .title-outer-container {
      $title-background-color: #007A4B; // #105D2A;
      background: $title-background-color;
      border: 0.1em groove rgba(lighten($title-background-color, 8), 0.15);
      border-radius: 50%;
      width: 2.1em;
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
