import { sveltekit } from '@sveltejs/kit/vite'
import unocss from 'unocss/vite'

export default {
  plugins: [unocss(), sveltekit()],
}
