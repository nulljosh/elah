# Bible brand kit and design system

An open book with a ribbon marker: scripture, one tap from the passage you were on.

## The mark
One bold flat white glyph on an accent gradient tile. No text, no outline, no emblem.

- `../Bible.icon` is the source of truth (Icon Composer). Light and dark fills are set in it.
- `../icon.svg` is the flat copy for READMEs (shown at 80 px). `icon-1024.png` is the App Store icon, no alpha.
- `mark.svg` is the glyph alone in `currentColor` for your own background.
- Two pages with a gap for the spine and a notched ribbon tail. Clear space equal to the width of the ribbon.
- Reads at 29 px: the pages stay two white blocks and the ribbon stays a tick below them. Smallest size 16 px.

## Colour
Warm paper in light, warm graphite in dark, the same neutrals as Hermes. One accent, flat surfaces, no gradients except the icon tile, no shadows.

| Role | Light | Dark |
|---|---|---|
| Accent (actions, links, focus) | `#1745a8` | `#6ea8ff` |
| Button fill in dark | | `#2f66d0` |
| Icon tile | `#4f8df0` to `#1745a8` | same |
| Background | `#faf8f4` | `#171614` |
| Surface (controls, hover) | `#f1ede6` | `#211f1c` |
| Line | `#e3ddd3` | `#33302b` |
| Text | `#1f1d1a` | `#f3efe8` |
| Secondary text | `#6b655c` | `#9a948a` |

The accent is a deep royal blue. It is for the Go button, focus rings and the icon, nowhere else. Never brown, beige, purple or teal.

## Type
Bible Sans, the house face for this app: Inter under the SIL Open Font License, proportionally spaced in the spirit of San Francisco and Helvetica, renamed and pinned by `scripts/gen_font.py`, with the curly quotes and apostrophe redrawn as the smooth stones David took from the brook. Four weights, 400 to 700, in `fonts/`, shipped in the app bundle and on the landing. The fallback is the system stack. Verses can switch to the system serif in Reading settings. Scale: display 64/64 bold, title 34/40 bold, headline 20/28 semibold, body 17/24, footnote 13/16.

## Art
Gustave Doré's Bible engravings (1866, public domain), dithered to halftone dot masks in `landing/art/` and tinted with the band colour. The footer is the Bible's cross-references drawn as arcs (OpenBible.info, CC BY), after Chris Harrison and Christoph Römhild, cut into fine rules like the Hermes footer.

## Space and shape
- Space on the 8 point grid: 4, 8, 12, 16, 24, 32, 48. Side margin 20. Reading column 680.
- Radii: cards 28, grouped lists 20, controls fully round, icon 22 percent.
- Controls are 48 points tall capsules, one height in a row. Focus is a 4 point ring at 30 percent accent.
- Motion is 0.2 s ease and honours reduced motion.

`tokens.css` is the single source for the landing; `app/Sources/Theme.swift` mirrors it. `deploy.sh` copies it and the fonts into `landing/` so the page and the kit never drift.
