# Bible

One page that opens on David and Goliath (1 Samuel 17, NIV) and reads any passage in the NIV or the King James. A search box and a version picker drive a frame of BibleGateway. There is no build step and no dependency.

- The app is `landing/index.html`. It builds `https://www.biblegateway.com/passage/?search=<ref>&version=<NIV|KJV>` and sets it as the frame source. The home button resets to `1 Samuel 17` in NIV.
- BibleGateway sends no `X-Frame-Options` (checked 2026-10-30). If that changes the frame goes blank. Fall back to a text API with a licence that covers NIV, or to KJV from a public domain source.
- Versions are NIV and KJV only. Joshua chose them, so do not add others without being asked.
- Design tokens: `brand/tokens.css`, the single source. `./deploy.sh` copies it, `icon.svg`, `mark.svg` and the favicons into `landing/`, then runs `wrangler deploy` to bible.jaybulb.com. A push deploys nothing.
- Icon: `Bible.icon` (Icon Composer), made by `make_brand.py` from the brand skill. Glyph is an open book with a ribbon, accent `#1745a8`. Rebuild through the `brand` skill, never hand-edit `icon-1024.png`.
- `docs/roadmap.md` holds the parity matrix and version plan. Versions follow honest semver: features are minors, fixes are patches, a major only on Joshua's call.
- Never add accounts, analytics or ads. Free or $1, nothing else.
