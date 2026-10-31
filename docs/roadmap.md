# Bible roadmap

Goal: a Bible reader that matches the YouVersion Bible app for everyday reading, with its own brand and code. It opens on David and Goliath, 1 Samuel 17, in the NIV, and reads the NIV and the King James. The native app reads the KJV from text bundled in the app and opens the NIV on BibleGateway, since Biblica licenses the NIV.

Reference: the YouVersion Bible app and biblegateway.com. Re-check the matrix every version.

## Parity matrix (v1.0.0)

| Area | YouVersion | Bible | Status |
|---|---|---|---|
| Open on a chosen passage | no, resumes | opens on David and Goliath, one button returns to it | done |
| Read a passage by reference | yes | search box, any book, chapter or range | done (BibleGateway does the parsing) |
| Versions | 2,000+ | NIV and KJV | done, on purpose |
| Light and dark | yes | follows the system | done |
| Landing, brand kit, icon, design system | n/a | tokens, Icon Composer bundle, brand doc | done (0.2) |
| Previous and next chapter | yes | yes, native | done (0.3) |
| Book and chapter picker | yes | yes, native | done (0.3) |
| Resume where you left off | yes | Continue reading card | done (0.7) |
| Link to a passage and version | yes | no | todo |
| Text size and reading theme | yes | size, typeface, spacing | done (0.5) |
| Keyword search across the Bible | yes | yes, offline | done (0.6) |
| Parallel versions side by side | yes | no | todo |
| Verse of the day | yes | yes | done (0.7) |
| Highlights, bookmarks, notes | yes | yes, on the device | done (0.9) |
| Share a verse | yes | as text or an image card | done (1.1) |
| Reading plans and streaks | yes | no | todo |
| Audio Bible | yes | on-device voice | done (0.8) |
| Cross references and footnotes | yes | inside the frame only | partial |
| Offline reading | yes | KJV offline | done (0.3) |
| Account and sync | yes | no | skip until highlights exist, then jaybulb-api |
| Widgets and Apple Watch | yes | no | todo |
| Ads, social feed, gamified badges | yes | no | skip, never |

## App Store gap matrix (2026-10-30)

Read from the App Store screenshots of YouVersion, Bible Gateway, Dwell, ESV, Olive Tree, Logos and Blue Letter Bible. Borrow the idea, never their brand or words. Skipped on purpose: ads, social feeds, paywalls, study-Bible stores.

| Gap | Who has it | Size | Status |
|---|---|---|---|
| Native reader, offline KJV, chapter steps, book and chapter grid | all | M | done (0.3) |
| Reference chip in the top bar opens the picker | YouVersion, Bible Gateway | S | done (0.3) |
| Tap a verse: highlight in four colours, copy, share, bookmark | YouVersion, ESV, Bible Gateway | M | done (0.4) |
| Reading settings sheet: size, serif or sans, line spacing | YouVersion, Dwell, Bible Gateway | S | done (0.5) |
| Search every verse, results grouped by book | Olive Tree, Logos | M | done (0.6) |
| Today screen: continue reading, verse of the day | Bible Gateway, YouVersion | M | done (0.7) |
| Listen: on-device voice reads the chapter, verse follows | Dwell, YouVersion, ESV | M | done (0.8) |
| Notes on a verse, all notes in one list | Bible Gateway, ESV, Olive Tree | M | done (0.9) |
| Saved tab: highlights, bookmarks, notes | YouVersion, ESV | S | done (0.9) |
| Share a verse as an image card | YouVersion, Bible Gateway | S | done (1.1) |
| Listening bar: pause, skip a verse, speed | Dwell, Blue Letter Bible, Bible Gateway | S | 1.2 |
| Search scope (Old or New Testament) and exact phrase in quotes | Blue Letter Bible, Logos | S | 1.3 |
| Reading plans with a daily check-off | YouVersion, ESV, Dwell, Logos | L | 2.0 |
| Cross references and Strong's numbers (public domain KJV data) | Olive Tree, Blue Letter Bible, Logos | L | 3.0 |
| Home Screen widget and Mac desktop widget, verse of the day | YouVersion | M | 4.0 |
| Apple Watch verse of the day | none | M | 5.0 |
| NIV inside the app | all | L | blocked on a Biblica licence |

## Version plan

Each version closes rows above and refreshes both matrices. Every release ships iPhone, iPad, Mac and the web page together.

- 0.1 one page over BibleGateway (done)
- 0.2 brand kit, blue icon, design system, repo, landing (done)
- 0.3 native SwiftUI app for iPhone, iPad and Mac: bundled KJV, David and Goliath home, chapter steps, book grid, text size, NIV opens BibleGateway in a Safari sheet (done)
- 0.4 verse actions: press and hold a verse to highlight in four colours, bookmark, copy or share (done)
- 0.5 reading settings: text size slider, sans or serif, three line spacings (done)
- 0.6 search: every KJV verse on the device, all words must match, grouped by book (done)
- 0.7 Today tab: greeting, continue reading, a verse of the day from 67 well-known verses, share (done)
- 0.8 listen: the system voice reads the chapter and outlines the verse it is on, keeps playing in the background; Search moved to its own tab (done)
- 0.9 notes on any verse and a Saved tab with bookmarks, highlights and notes in canon order (done)
- 1.0 first major, Joshua's call 2026-10-30 (done): every gap row from 0.3 to 0.9 closed, QA'd on iPhone, iPad and Mac in light and dark, 8 tests. Still open from the 1.0 bar: the App Store listing (blocked on the Apple web login) and the opus-ad film
- 1.1 share a verse as a square image card in the brand blue, from any verse or the verse of the day (done)
- 1.2 listening bar: pause, previous and next verse, speed
- 1.3 search scope and exact phrase
- 2.0 reading plans: start a plan, today's chapters on the Today tab, check them off, progress
- 3.0 cross references and Strong's
- 4.0 widgets
- 5.0 Apple Watch
- 6.0 iPad split view: text beside notes or a second chapter
- 7.0 Shortcuts and Siri: "read 1 Samuel 17"
- 8.0 sync highlights and notes through iCloud, no account
- 9.0 the 27 interface languages the fleet ships
- 10.0 NIV in the app if Biblica licenses it, otherwise a second public domain version beside the KJV (Joshua picks)

## Licensing

BibleGateway supplies the NIV and the licence that goes with it. The KJV is public domain. The NIV is not: Biblica licenses it, so a native app or an own-text source needs a licence or a licensed API before it ships. Settle that before 0.6. Until then the frame is the product.

## Beyond YouVersion

Ideas it does not have, none started: a home you choose and one button back to it, passage links that carry the version, no account at all.
