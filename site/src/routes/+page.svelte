<script>
  import { onMount } from 'svelte'

  import { browser } from '$app/environment'

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
      (16 * factor * (0 | devicePixelRatio)) / devicePixelRatio + 'px'
    )
  }

  let els
  const rpx = () => {
    for (let el of els) {
      el.style.marginLeft = el.style.marginRight = 'auto'
      const m =
        0 |
        getComputedStyle(el).getPropertyValue('margin-left').replace('px', '')
      console.log(m)
      el.style.marginLeft = m + 'px'
    }
  }

  let factor = 1
  $: if (browser) factor, updpi()
  let loaded = false

  onMount(() => {
    els = document.querySelectorAll('section')
    rpx()
    updpi()
    loaded = true
  })
</script>

<svelte:head>
  <title>kirsch</title>
</svelte:head>

<svelte:window on:resize={rpx} />

<div class="{loaded ? 'opacity-100' : 'opacity-0'} transition-opacity w-screen">
  <section>
    <h1>kirsch</h1>
    <p>
      Grumpy wizards make toxic brew for the evil Queen and Jack. One morning,
      when Gregor Samsa woke from troubled dreams, he found himself transformed
      in his bed into a horrible vermin. He lay on his armour-like back, and if
      he lifted his head a little he could see his brown belly, slightly domed
      and divided by arches into stiff sections. The bedding was hardly able to
      cover it and seemed ready to slide off any moment. His many legs,
      pitifully thin compared with the size of the rest of him, waved about
      helplessly as he looked.
    </p>
  </section>
</div>

<style>
  :global(*) {
    @apply font-normal line-height-none;
  }

  :global(:root) {
    @apply text-fg bg-bg;
    font-family: kirsch;
    font-size: var(--sz);
    -moz-osx-font-smoothing: grayscale;
    font-smooth: never;
    filter: contrast(100.00001%);
  }

  :global(body) {
    text-size-adjust: none;
    -webkit-text-size-adjust: none;
  }

  :global(section) {
    @apply mx-auto max-w-[80ch] px-8;
  }

  :global(h1) {
    @apply text-[5rem] my-[3rem];
  }

  :global(h2) {
    @apply text-[3rem] my-[2rem];
  }

  :global(h3) {
    @apply text-[2rem] my-[1rem];
  }

  :global(p) {
    @apply hyphens-auto;
  }
</style>
