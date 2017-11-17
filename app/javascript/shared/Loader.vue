<template>
  <section class='loader'>
    <div class='loading-container'>
      <div class='loading'>
      </div>
    </div>
  </section>
</template>

<style lang='scss' scoped>
  @keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
  }

  @keyframes fadein {
    from { opacity: 0; }
    to   { opacity: 1; }
  }

  .loader {
    width: 100%;
    height: 100%;
    position: absolute;
    top: 0;
    left: 0;
    pointer-events: none;
    animation-delay: 2s;
    animation: fadein 1s;

    .loading-container {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);

      .loading {
        border: 0.1rem solid #f3f3f3; /* Light grey */
        border-top: 0.1rem solid #3498db; /* Blue */
        border-radius: 50%;
        width: 4rem;
        height: 4rem;
        animation: spin 1s linear infinite;
      }
    }
  }
</style>
