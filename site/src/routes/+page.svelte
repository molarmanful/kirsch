<script>
  import { onMount } from 'svelte'

  let rm = () => {}
  const updpi = () => {
    rm()
    const media = matchMedia(`(resolution: ${devicePixelRatio}x)`)
    media.addEventListener('change', updpi)
    rm = () => {
      media.removeEventListener('change', updpi)
    }

    document.documentElement.style.setProperty(
      '--sz',
      16 / devicePixelRatio + 'px'
    )
  }

  onMount(() => {
    updpi()
  })
</script>

<svelte:head>
  <title>kirsch</title>
</svelte:head>

<p>testing testing 123</p>

<style>
  :global(:root) {
    font-family: kirsch;
    font-size: var(--sz);
  }
</style>
