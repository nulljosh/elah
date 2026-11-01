# Elah (repo and folder were bible)

One page that opens on David and Goliath (1 Samuel 17) and reads any passage in the King James. A search box drives it. There is no build step and no dependency.

- The web reader is `landing/read.html`. It loads `kjv.json` (copied from `app/Sources/Resources/` by `deploy.sh`, gitignored in `landing/`) and renders the passage as text. References: `Book`, `Book 3`, `Book 3:16`, `Book 3:16-18`, book names match by prefix.
- Native app: `app/` (xcodegen `project.yml`, one SwiftUI target for iPhone, iPad and Mac, bundle id `com.nulljosh.bible`). KJV is bundled as `app/Sources/Resources/kjv.json` (public domain text, cleaned from thiagobodruk/bible, MIT). KJV only. The NIV and its BibleGateway sheet were cut 2026-10-31 so nothing in the app is web (Joshua's call, after the 1.3.0 rejection). Build: `cd app && xcodegen generate && xcodebuild -scheme Bible -destination 'platform=macOS' test`. QA launch flag: `-showBooks YES` opens the book picker.
- The King James only (Joshua, 2026-10-31). Do not add versions without being asked.
- Design tokens: `brand/tokens.css`, the single source. `./deploy.sh` copies it, `icon.svg`, `mark.svg` and the favicons into `landing/`, then runs `wrangler deploy` to elah.jaybulb.com (bible.jaybulb.com still serves). A push deploys nothing.
- Icon: `Bible.icon` (Icon Composer), made by `make_brand.py` from the brand skill. Glyph is an open book with a ribbon, accent `#1745a8`. Rebuild through the `brand` skill, never hand-edit `icon-1024.png`.
- `docs/roadmap.md` holds the parity matrix and version plan. Versions follow honest semver: features are minors, fixes are patches, a major only on Joshua's call.
- Never add accounts, analytics or ads. Free or $1, nothing else.

## The loop

A `/loop` builds the roadmap in `docs/roadmap.md` one version at a time. Its state, next steps and restart prompt are in [docs/LOOP-HANDOFF.md](docs/LOOP-HANDOFF.md). Read it before picking the next version or touching the store steps.
