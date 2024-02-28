import extractorSvelte from '@unocss/extractor-svelte'
import {
  presetUno,
  transformerDirectives,
  transformerVariantGroup,
} from 'unocss'

export default {
  presets: [presetUno({ dark: 'class' })],
  transformers: [transformerDirectives(), transformerVariantGroup()],
  rules: [],
  shortcuts: [
    {
      screen: 'w-screen h-screen',
      full: 'w-full h-full',
      'max-full': 'max-w-full max-h-full',
      'max-screen': 'max-w-screen max-h-screen',
    },
    [/^ofade-([\d]*)$/, ([, c]) => `transition-opacity duration-${c}`],
  ],
  extractors: [extractorSvelte],
}
