<script>
  import '@unocss/reset/sanitize/sanitize.css'
  import '@unocss/reset/sanitize/assets.css'
  import 'uno.css'
</script>

<slot />

<style>
  @font-face {
    font-family: 'kirsch';
    font-style: normal;
    font-weight: 500;
    src:
      local(''),
      url('/kirsch.woff2') format('woff2');
  }

  :root {
    font-family: 'kirsch';
    font-size: 15px;
  }

  h1 {
    font-size: 300%;
  }

  h2 {
    font-size: 200%;
  }
</style>
