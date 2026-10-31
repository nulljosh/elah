# Bible roadmap

Goal: a Bible reader that matches the YouVersion Bible app for everyday reading, with its own brand and code. It opens on David and Goliath, 1 Samuel 17, in the NIV, and reads the NIV and the King James. Today it is one page over BibleGateway. Native apps come once the text has a source we are licensed to ship.

Reference: the YouVersion Bible app and biblegateway.com. Re-check the matrix every version.

## Parity matrix (v0.2.0)

| Area | YouVersion | Bible | Status |
|---|---|---|---|
| Open on a chosen passage | no, resumes | opens on David and Goliath, one button returns to it | done |
| Read a passage by reference | yes | search box, any book, chapter or range | done (BibleGateway does the parsing) |
| Versions | 2,000+ | NIV and KJV | done, on purpose |
| Light and dark | yes | follows the system | done |
| Landing, brand kit, icon, design system | n/a | tokens, Icon Composer bundle, brand doc | done (0.2) |
| Previous and next chapter | yes | no | todo |
| Book and chapter picker | yes | no | todo |
| Resume where you left off | yes | no | todo (home stays David and Goliath) |
| Link to a passage and version | yes | no | todo |
| Text size and reading theme | yes | no | todo |
| Keyword search across the Bible | yes | no | todo |
| Parallel versions side by side | yes | no | todo |
| Verse of the day | yes | no | todo |
| Highlights, bookmarks, notes | yes | no | todo |
| Share a verse as an image | yes | no | todo |
| Reading plans and streaks | yes | no | todo |
| Audio Bible | yes | no | todo |
| Cross references and footnotes | yes | inside the frame only | partial |
| Offline reading | yes | no | todo |
| Account and sync | yes | no | skip until highlights exist, then jaybulb-api |
| Widgets and Apple Watch | yes | no | todo |
| Ads, social feed, gamified badges | yes | no | skip, never |

## Version plan

Each version closes a block of rows above and refreshes the matrix.

- 0.1 one page, search box and version picker over BibleGateway (done)
- 0.2 brand kit, blue icon, design system, repo, landing, KJV and NIV only, David and Goliath home (done)
- 0.3 chapter navigation: previous, next and a book picker
- 0.4 passage links (`?q=` and `?v=`) and resume where you left off
- 0.5 text size and reading theme
- 0.6 own text source behind the same UI, so the frame is optional (KJV first, it is public domain)
- 0.7 keyword search
- 0.8 parallel versions
- 0.9 verse of the day
- 1.0 first major, only on Joshua's call: every row above done, QA'd on phone width, a Mobbin pass and an opus-ad film
- then bump the matrix to 1:1 and keep going with polish and speed

## Long plan

A plan, not a promise. Versions climb one block at a time; majors get the full QA pass.

- 0.x: the reader. Navigation, links, resume, text size, own text, search, parallel, verse of the day.
- 1 to 9: study tools. Highlights, bookmarks, notes, share as image, reading plans, cross references. Sync through jaybulb-api once there is something to sync.
- 10 to 19: iPhone and Mac in SwiftUI with the same brand, widgets, an Apple Watch verse. Kotlin module for Android.
- 20 to 49: offline packs per version, audio, the 27 interface languages the rest of the fleet has.
- 50 to 99: speed, accessibility, VoiceOver and Dynamic Type everywhere, store listing at free or $1.
- 100: anyone can open it anywhere with no account, and it still opens on the passage you picked.
- 1000: no plan that far.

## Licensing

BibleGateway supplies the NIV and the licence that goes with it. The KJV is public domain. The NIV is not: Biblica licenses it, so a native app or an own-text source needs a licence or a licensed API before it ships. Settle that before 0.6. Until then the frame is the product.

## Beyond YouVersion

Ideas it does not have, none started: a home you choose and one button back to it, passage links that carry the version, no account at all.
