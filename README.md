<div align="center">

![kirsch](./img/header.png)

</div>

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Overview](#overview)
- [Gallery](#gallery)
- [Installation](#installation)
  - [Web](#web)
  - [Manually Building](#manually-building)
- [Design Notes](#design-notes)
  - [Flourishes](#flourishes)
  - [Gaps](#gaps)
- [TODO](#todo)
- [Contributing](#contributing)
- [Credits](#credits)
- [Licensing](#licensing)

## Overview

**kirsch** /ˈkɪərʃ/ _n._

1. _(German)_ cherry.

1. _(Russell A. Kirsch, 1929 - 2020)_ American engineer recognized as the
   developer of the first digital image scanner and the inventor of the pixel.

1. A monospace bitmap font with a 6x16 bounding box (5px avg width, 4px
   descent, 12px ascent, 5px x-height, 9px cap height). It draws from a variety
   of letterforms and motifs to create a distinct humanist feel at a compact
   size.

   Some glyphs come from [Cozette](https://github.com/slavfox/Cozette), often
   with modifications to adhere to kirsch's design.

## Gallery

<details>
<summary><strong>Glyphs</strong></summary>
<div align="center">

![kirsch glyphs](./img/chars.png)

</div>
</details>

<details>
<summary><strong>Glyphs Map</strong></summary>
<div align="center">

![kirsch glyph map](./img/map.png)

</div>
</details>

<details open>
<summary><strong>Samples</strong></summary>
<div align="center">

![kirsch sample](./img/sample.png)

</div>
</details>

## Installation

Download from [Releases](https://github.com/molarmanful/kirsch/releases).
Included are bitmap formats - OTB, BDF, PCF, DFONT (for Mac users) - as well as TTF.
2x versions are available for HiDPI screens. Note that PCF doesn't contain
glyphs past U+FFFF.

For the crispiest viewing experience, try to use the bitmap formats when
possible. If bitmap fonts are not supported on your platform (e.g. Windows,
VSCode), then use the TTF at font sizes that are multiples of 16px.

> **Quick Tip**: If you need font size in pt, use the following conversion:
>
> `pt = px * 72 / dpi`
>
> e.g. 13px on a 96dpi screen is `16px * 72 / 96dpi = 12pt`.

Patched Nerd Fonts are available. The "Mono" variant uses smaller glyphs
(single- instead of double-width) and works for terminals that can't mix
widths.

### Web

I would generally discourage usage of kirsch on the web due to lack of bitmap
support. But for the stubborn and the brave, WOFF2 is available. There is also
a [CDN-hosted
stylesheet](https://cdn.jsdelivr.net/npm/kirsch@latest/kirsch.css) for
convenience.

```html
<link
  rel="stylesheet"
  href="https://cdn.jsdelivr.net/npm/kirsch@latest/kirsch.css"
/>
```

### Manually Building

Requirements:

- Java (for [Bits'n'Picas](https://github.com/kreativekorp/bitsnpicas))
- FUSE (e.g. `apt install fuse`)

Optional:

- HarfBuzz utilities (e.g. `apt install libharfbuzz-bin`)
- `bdfresize` (e.g. `apt install bdfresize`)
- `bdftopcf` (e.g. `apt install xfonts-utils`)
- `compress_woff2` (e.g. `apt install woff2`)

`git clone` and run `build.sh`. Font files output to `out/`.

`build.sh` downloads into `deps/`:

- A FontForge AppImage for generating bitmap formats from BDF.
- A Bits'n'Picas binary. If you wish, you can use this binary
  (instead of or alongside FontForge) to view glyphs and build desired font
  formats not found on the Releases page.
- A Nerd Fonts Patcher, which requires `-n` to activate.

HarfBuzz utilities are necessary if you wish to use `img.sh` to generate the
images found in `img/`, but is otherwise unused in the building of the final
font files. `bdfresize` is for generating HiDPI fonts. `bdftopcf` is for
generating PCF fonts. `compress_woff2` is for generating WOFF2 fonts.

## Design Notes

Unlike my previous font [eldur](https://github.com/molarmanful/eldur), which
had a mere 4px avg. char width to work with, kirsch has a 5px avg. char width.
That 1px of extra width affords a surprising amount of leeway for the design.
Far more glyphs fit comfortably into 5px width - e.g. "m" and "w" - meaning that
those glyphs won't break kerning and intrude on the spaces of neighboring
glyphs. Glyphs that don't fit into 5px width can now work with 7px width, which
maintains balance and legibility without affecting kerning too negatively.

### Flourishes

![rogue fijian xylophone](./img/design-flourishes.png)

The flourishes - e.g. in "i" or "f" - are a stylistic choice, but they also
serve a functional purpose. Without the flourishes, "i" would take up 1px of
width, leaving 4px of awkward space. 2px flourishes on each side of the "i"
give it a 5px width, thereby addressing the kerning issue in a stylish way.

In "l"'s case, the script-style flourishes further distinguish it from other
vertical characters like `1I|`.

### Gaps

![bad queen peg 69](./img/design-gaps.png)

One of kirsch's distinctive features is the presence of a gap at the bowls of
the letters. Filling in the gap would make the letters either too square or too
bunched-up, while leaving the gap open declutters the letterforms. The gaps
also evoke script-style stroke endings.

## TODO

- More Unicode support
- Ligatures

## Contributing

Issues, feature/glyph requests, and pull requests are all welcome!

## Credits

These are projects that have inspired/helped me create kirsch and are 100% worth
checking out.

- [Bits'n'Picas](https://github.com/kreativekorp/bitsnpicas)
- [Cozette](https://github.com/slavfox/Cozette)
- [Cyreal Font Testing Page](http://www.cyreal.org/Font-Testing-Page/)
- [W3 UTF-8 Demo](https://www.w3.org/2001/06/utf-8-test/UTF-8-demo.html) /
  [Markus Kuhn UTF-8 Demo](https://antofthy.gitlab.io/info/data/utf8-demo.txt)
- [APL386](https://abrudz.github.io/APL386)

## Licensing

Made with ♥ by Ben Pang. Released under the OFL-1.1 License.
