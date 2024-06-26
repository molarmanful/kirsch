<script>
  import { onMount } from 'svelte'

  import { browser } from '$app/environment'
  import { Header } from '$lib'

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
  <Header />

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
