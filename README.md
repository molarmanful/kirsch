<div align="center">

![kirsch](./img/header.png)

</div>

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Overview](#overview)
- [Gallery](#gallery)
- [Installation](#installation)
  - [Manually Building](#manually-building)
- [Design Notes](#design-notes)
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
    <summary>Supported characters</summary>
![kirsch chars](./img/chars.png)
</details>

<div align="center">

![kirsch sample](./img/sample.png)

</div>

## Installation

Download from [Releases](https://github.com/molarmanful/kirsch/releases).
Included are bitmap formats - OTB, BDF, DFONT (for Mac users) - as well as TTF.
2x versions are available for HiDPI screens.

For the crispiest viewing experience, try to use the bitmap formats when
possible. If bitmap fonts are not supported on your platform (e.g. Windows,
VSCode), then use the TTF at font sizes that are multiples of 16px.

> **Quick Tip**: If you need font size in pt, use the following conversion:
>
> `pt = px * 72 / dpi`
>
> e.g. 13px on a 96dpi screen is `16px * 72 / 96dpi = 12pt`.

### Manually Building

Requirements:

- Java (for [Bits'n'Picas](https://github.com/kreativekorp/bitsnpicas))
- [bdfresize](https://github.com/ntwk/bdfresize) (e.g. `apt install bdfresize`)
- FUSE (e.g. `apt install fuse`)

Optional:

- [HarfBuzz Utilities](https://harfbuzz.github.io/utilities.html) (e.g.
  `apt install libharfbuzz-bin`)

`git clone` and run `build.sh`. Font files output to `out/`.

`build.sh` downloads FontForge as an AppImage at `deps/` for generating bitmap
formats from BDF. `build.sh` also downloads a Bits'n'Picas binary at `deps/`.
If you wish, you can use this binary (instead of or alongside FontForge) to
view glyphs and build desired font formats not found on the Releases page.

HarfBuzz (or more specifically, `hb-view`) is necessary if you wish to use
`img.sh` to generate the images found in `img/`, but is otherwise unused in the
building of the final font files.

## Design Notes

Unlike my previous font [eldur](https://github.com/molarmanful/eldur), which
had a mere 4px avg. char width to work with, kirsch has a 5px avg. char width.
That 1px of extra width affords a surprising amount of leeway for the design.
Far more glyphs fit comfortably into 5px width - e.g. "m" and "w" - meaning that
those glyphs won't break kerning and intrude on the spaces of neighboring
glyphs. Glyphs that don't fit into 5px width can now work with 7px width, which
maintains balance and legibility without affecting kerning too negatively.

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
