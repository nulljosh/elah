# Elah roadmap

Goal: a Bible reader that matches the YouVersion Bible app for everyday reading, with its own brand and code. It opens on David and Goliath, 1 Samuel 17, and reads the King James, the same bundled public domain text on the web and in the app. The NIV and its BibleGateway frame and sheet were cut 2026-10-31 so nothing is web.

Reference: the YouVersion Bible app and biblegateway.com. Re-check the matrix every version.

## Parity matrix (v1.0.0)

| Area | YouVersion | Bible | Status |
|---|---|---|---|
| Open on a chosen passage | no, resumes | opens on David and Goliath, one button returns to it | done |
| Read a passage by reference | yes | search box, any book, chapter or range | done (BibleGateway does the parsing) |
| Versions | 2,000+ | KJV | done, on purpose |
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
| Cross references and footnotes | yes | cross references on every verse, offline | done (1.4) |
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
| Listening bar: pause, skip a verse, speed | Dwell, Blue Letter Bible, Bible Gateway | S | done (1.2) |
| Search scope (Old or New Testament) and exact phrase in quotes | Blue Letter Bible, Logos | S | done (1.3) |
| Reading plans with a daily check-off | YouVersion, ESV, Dwell, Logos | L | 2.0 |
| Cross references and Strong's numbers (public domain KJV data) | Olive Tree, Blue Letter Bible, Logos | L | 3.0 |
| Home Screen widget and Mac desktop widget, verse of the day | YouVersion | M | 4.0 |
| Apple Watch verse of the day | none | M | 5.0 |
| NIV inside the app | all | L | blocked on a Biblica licence |

## Unique (the answer to 4.3)

Apple rejected iOS 2.1.0 and Mac 1.3.0 on 2026-11-03 under 4.3(a): too close to other Bible readers, ours and theirs. These are what only Elah does. Each ships as its own minor and leads the listing.

| Feature | Status |
|---|---|
| Map tab: every cross reference as arcs (after Harrison and Römhild), drag to light a chapter, open what it reaches | 2.2 |
| Doré engravings at the head of their chapters, and a strip of them on Today | 2.2 (nine plates; the full 241 to come) |
| Listing rebuilt around the Map and the engravings: subtitle, description, keywords, screenshots | 2.2 |
| All 241 Doré plates, dithered by `scripts/` from the Commons scans | next |
| Arcs inside the reader: tap a verse's cross references to see them on the map | next |

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
- 1.2 listening bar above the tabs: pause, previous and next verse, four speeds, stop (done)
- 1.3 search scope and exact phrase in quotes; Bible Sans, the app's own font, in the app and on a rebuilt landing (done)
- 1.4 cross references on any verse (top 8 by votes, OpenBible.info CC BY), animated launch splash; Mac build on the store record (done)
- 1.5 daily verse notification: a toggle and time on Today, the next 30 verses queued as local notifications (done)
- 2.0 reading plans (done): four plans (Gospels and Psalms in 30 days, New Testament in 90, the whole Bible in a year), the next day's chapters on Today, check a day off, progress bar. Still owed for the major: a Mobbin pass and the opus-ad film
- 2.1 nine public domain Bibles as real text, picked from the top bar: KJV, BSB, ASV, New Heart, Young's, Darby, Webster, Basic English, Geneva (done)
- 2.2 the Map and the Doré engravings, listing rebuilt around them, the answer to 4.3 (done in code; App Store build pending)
- 2.3 arcs in the reader: a verse's cross references open as a small map of where they land, "See on the Map" jumps to the chapter
- 2.4 Map filters: one book's arcs only, Old or New Testament, strongest links only; pinch to zoom on iPhone and iPad, scroll to zoom on Mac
- 2.5 Stories: the great narratives as trails through their chapters (David, Moses, Abraham, Joseph, Elijah, Daniel, Jesus), each led by its engraving
- 3.0 the Bible you can see (major): Today opens on the engraving and the arcs of the day's chapter; Map, Engravings and Stories reach every screen; a Mobbin pass and the commercial
- 4.0 widgets: the verse of the day with its plate, and the day's reading, on iPhone, iPad and the Mac desktop
- 5.0 Apple Watch: the verse of the day, a complication, the chapter read aloud
- 6.0 iPad and Mac side by side: a chapter beside its cross references, or two versions in parallel
- 7.0 Shortcuts and Siri: "read 1 Samuel 17", "what links to Psalm 23"
- 8.0 sync highlights, notes and plans through iCloud, still no account
- 9.0 the interface in many languages, and public domain Bibles beyond English (Luther 1545, Reina-Valera 1909, Louis Segond 1910)
- 10.0 Strong's numbers on the King James: tap a word for its Hebrew or Greek and every verse that uses it

## Licensing

The KJV is public domain and is the only version. The NIV would need a licence from Biblica, so it stays out.

## Beyond YouVersion

Ideas it does not have, none started: a home you choose and one button back to it, passage links that carry the version, no account at all.

## Ingested 2026-10-31
- [ ] iOS 1.3.0 was rejected and that submission is cancelled; its reason was never read. iOS 2.1.0 is WAITING_FOR_REVIEW and Mac 1.3.0 is still waiting. Read Apple's notes with `asc web review show --app 6829146794` once Apple sign-in clears the throttle, then answer with the nine answers. Nothing goes to Apple without Joshua's yes.
