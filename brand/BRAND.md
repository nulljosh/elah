# Elah brand kit and design system

Five cross references on one line, coloured by reach: the Bible's own map, the thing only Elah draws.

## The mark
Five round-capped half circles on a night navy tile, longest blue to shortest gold, the dark arc palette. No text, no outline, no emblem. `scripts/gen_icon.js` draws every copy.

- `../Bible.icon` (bundle name kept from the first name) is the source of truth (Icon Composer). Light and dark fills are set in it.
- `../icon.svg` is the flat copy for READMEs (shown at 80 px). `icon-1024.png` is the App Store icon, no alpha.
- `mark.svg` is the arcs alone, for a dark background.
- Spans on the 1024 grid, base 696, stroke 58: 144 to 880, 144 to 624, 400 to 880, 272 to 528, 656 to 816. `ArcMark` in VerseImage.swift draws the same in the app (splash, share card).
- Reads at 28 px as a nest of coloured arches. Smallest size 16 px.

## Colour
White in light, neutral near-black in dark, cool greys between. No beige, sand or warm paper, ever. One accent, flat surfaces, no gradients except the icon tile, no shadows.

| Role | Light | Dark |
|---|---|---|
| Accent (actions, links, focus) | `#1745a8` | `#6ea8ff` |
| Button fill in dark | | `#2f66d0` |
| Icon tile | `#14254f` to `#070f24` | same |
| Background | `#ffffff` | `#0f1012` |
| Surface (controls, hover) | `#f3f4f6` | `#1a1b1e` |
| Line | `#e3e5e9` | `#2c2e33` |
| Text | `#16181c` | `#f2f3f5` |
| Secondary text | `#5d636c` | `#9aa0a9` |

The accent is a deep royal blue. It is for the Go button and focus rings, nowhere else. Never brown, beige, purple or teal.

## Type
Elah Sans, the house face for this app: Inter under the SIL Open Font License, proportionally spaced in the spirit of San Francisco and Helvetica, renamed and pinned by `scripts/gen_font.py`, with the curly quotes and apostrophe redrawn as the smooth stones David took from the brook. Four weights, 400 to 700, in `fonts/`, shipped in the app bundle and on the landing. The fallback is the system stack. Verses can switch to the system serif in Reading settings. Scale: display 64/64 bold, title 34/40 bold, headline 20/28 semibold, body 17/24, footnote 13/16.

## Art
Gustave Doré's Bible engravings (1866, public domain), dithered to halftone dot masks in `landing/art/` and tinted with the band colour. The footer is the Bible's cross-references drawn as arcs (OpenBible.info, CC BY), after Chris Harrison and Christoph Römhild, cut into fine rules like the Hermes footer.

## Space and shape
- Space on the 8 point grid: 4, 8, 12, 16, 24, 32, 48. Side margin 20. Reading column 680.
- Radii: cards 28, grouped lists 20, controls fully round, icon 22 percent.
- Controls are 48 points tall capsules, one height in a row. Focus is a 4 point ring at 30 percent accent.
- Motion is 0.2 s ease and honours reduced motion.

`tokens.css` is the single source for the landing; `app/Sources/Theme.swift` mirrors it. `deploy.sh` copies it and the fonts into `landing/` so the page and the kit never drift.
