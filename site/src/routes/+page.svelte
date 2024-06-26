<script>
  import { onMount } from 'svelte'

  import { browser } from '$app/environment'

  const adjust = n => (0 | (n * devicePixelRatio)) / devicePixelRatio

  let pxdiff = 1
  let rm = () => {}
  const updpi = () => {
    rm()
    const media = matchMedia(`(resolution: ${devicePixelRatio}x)`)
    media.addEventListener('change', updpi)
    rm = () => {
      media.removeEventListener('change', updpi)
    }
    pxdiff = (0 | devicePixelRatio) / devicePixelRatio
    document.documentElement.style.setProperty(
      '--sz',
      16 * factor * pxdiff + 'px'
    )
  }

  let els
  const rpx = () => {
    els = document.querySelectorAll('section, [rsz-x], [rsz-y]')
    for (let el of els) {
      if (el.matches('section, [rsz-x]')) {
        el.style.marginLeft = el.style.marginRight = 'auto'
      }
      if (el.matches('[rsz-y]')) {
        el.style.marginTop = el.style.marginBottom = 'auto'
      }
      requestAnimationFrame(() => {
        if (el.matches('section, [rsz-x]')) {
          el.style.marginLeft =
            adjust(
              getComputedStyle(el)
                .getPropertyValue('margin-left')
                .replace('px', '')
            ) + 'px'
        }
        if (el.matches('[rsz-y]')) {
          el.style.marginTop =
            adjust(
              getComputedStyle(el)
                .getPropertyValue('margin-top')
                .replace('px', '')
            ) + 'px'
        }
      })
    }
  }

  let factor = 1
  $: if (browser) factor, updpi()
  let loaded = false

  onMount(() => {
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
    <div class="bg-bg" rsz-x rsz-y>
      <h1 class="text-[8rem]">kirsch</h1>
      <h2>A versatile bitmap font with an organic flair.</h2>
      <div class="mt-16 flex gap-8">
        <a
          class="text-inherit"
          href="https://github.com/molarmanful/kirsch/releases"
          target="_blank"
        >
          <button class="text-[2rem]">DOWNLOAD</button>
        </a>
        <a
          class="text-inherit"
          href="https://github.com/molarmanful/kirsch"
          target="_blank"
        >
          <button class="text-[2rem]">GITHUB</button>
        </a>
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
    @apply max-w-[80ch] p-8;
  }

  :global([rsz-x]) {
    @apply mx-auto;
  }

  :global([rsz-y]) {
    @apply my-auto;
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
    @apply font-inherit text-([1rem] inherit) bg-transparent border-(1 solid current) px-[.75em] py-[.5em] cursor-pointer;
  }
</style>
