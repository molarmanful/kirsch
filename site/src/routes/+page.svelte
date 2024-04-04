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
      const style = getComputedStyle(el)
      if (el.matches('section, [rsz-x]')) {
        el.style.marginLeft = el.style.marginRight = 'auto'
        const m = 0 | style.getPropertyValue('margin-left').replace('px', '')
        el.style.marginLeft = m + 'px'
      }
      if (el.matches('[rsz-y]')) {
        el.style.marginTop = el.style.marginBottom = 'auto'
        const m = 0 | style.getPropertyValue('margin-top').replace('px', '')
        console.log(style.getPropertyValue('margin-top'), m)
        el.style.marginTop = m + 'px'
      }
    }
  }

  let factor = 1
  $: if (browser) factor, updpi()
  let loaded = false

  onMount(() => {
    els = document.querySelectorAll('section, [rsz-x], [rsz-y]')
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
  <header class="screen flex">
    <div class="m-auto bg-bg" rsz-x rsz-y>
      <h1 class="text-[8rem]">kirsch</h1>
      <h2>A versatile bitmap font with an organic flair.</h2>
      <div class="mt-16 flex gap-8">
        <button>ORDER</button>
        <button>ORDER</button>
        <button>ORDER</button>
      </div>
    </div>
  </header>

  <section>
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

  :global(section, [rsz-x], [rsz-y]) {
    @apply mx-auto max-w-[80ch] p-8;
  }

  :global(h1, h2, h3) {
    @apply my-[1em];
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

  :global(button) {
    @apply font-inherit text-([1rem] inherit) bg-transparent border-(1 solid current) px-3 py-2;
  }
</style>
