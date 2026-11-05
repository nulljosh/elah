# Elah loop handoff (2026-11-05, evening)

## What the loop is

One loop takes Elah, the Bible app for iPhone, iPad and Mac, up the version plan in `docs/roadmap.md` to 3.0. Each tick ships one minor: build it, QA it in light and dark, commit, tag, push, cut a GitHub release and deploy the landing.

## Where things stand

- The repo is at 2.2.0, tagged and released on GitHub but **not built**. It adds the Map, the Doré plates, the new icon (cross-reference arcs on navy, from `scripts/gen_icon.js`), Apache 2.0 and the code-review fixes.
- iOS 2.1.0 and Mac 1.3.0 were rejected under 4.3(a). 2.2.0 is the answer: build it and submit it on Joshua's Mac (steps below).
- ASC record 6829146794. Nine public domain Bibles are offline. App Privacy is Data Not Collected.

## App Review (read 2026-11-05 with asc web review show)

- iOS 2.1.0 and Mac 1.3.0 were both rejected on 2026-11-03 under **4.3(a) Design: Spam**: Apple says the binary, metadata or concept matches other apps with only minor differences. Extended review is flagged.
- Joshua replied on the iOS thread on 2026-11-04 asking which apps it looks like. Apple hasn't answered yet.
- The fix is to make Elah plainly not another generic Bible reader. Lead the listing, screenshots and first screen with what only Elah does (opens on David and Goliath, cross-reference arcs, nine offline Bibles, no account), and don't resubmit unchanged.

## Ship 2.2.0 (on Joshua's Mac, Xcode 26)

This Mac (Dad's, macOS 13, Xcode 15.2) can't build an App Store binary. Upstairs:

```sh
cd ~/Desktop/JoshCode/elah && git pull
cd app && xcodegen generate && xcodebuild -scheme Bible -destination 'platform=macOS' test && cd ..
asc workflow run upload-ios                      # archive and upload iOS 2.2.0, no submit
# Mac: archive with MacExportOptions.plist and upload the same way
asc metadata plan --app 6829146794 --dir metadata   # review the 2.2.0 listing diff, then the same with apply (flags: asc metadata apply --help)
```

New screenshots lead with the Map tab and a chapter with its engraving (iPhone, iPad, Mac; light). Then submit both platforms and paste the reply below on each rejection thread.

### Reply to App Review (both threads)

> Hello App Review,
>
> Thank you for the note. Version 2.2.0 makes Elah plainly its own app. It has a Map: every cross reference in the Bible drawn as one chart of arcs, Genesis to Revelation, which you drag to light up a chapter and open what it reaches. It also has Gustave Doré's 1866 engravings, set as halftone plates at the head of the chapters they illustrate. Both are the first things in the listing and the screenshots. The code, art and data are written for Elah alone and shared with no other app.
>
> Thank you,
> Joshua

## Next, in order

1. On Joshua's Mac: ship 2.2.0 (above). Check the new icon in Icon Composer (`Bible.icon`), then screenshot the Map, a plate chapter and the splash.
2. 2.3, arcs in the reader, then 2.4, 2.5 and 3.0, per the roadmap.
3. Code-review leftovers: one `RootView.open(_:)` for the three tab-switching closures; `ArcField.dimmed` is always true; decode `ArcMap.shared` lazily.

## Loop state (2026-11-05)

- Done: code-review fixes (the test compile error, vertical scroll over the Map, the speaker stopping on a chapter change, all links listed, the guide labels, the plate cache, stale brand tokens and swatches, the footer band height, cache-busting, hero highlights skipping the centre, no unused font preload), the new icon everywhere, Apache 2.0, v2.2.0 tagged and released.
- It type-checks against the macOS 14 SDK on Dad's Mac (`swiftc -typecheck -sdk /Library/Developer/CommandLineTools/SDKs/MacOSX14.2.sdk -target x86_64-apple-macos14.0 app/Sources/*.swift`), but it has never been built or run. Xcode 15.2 can't build it.
- QA: the icon was graded on `scripts/icon_sheet.js` sheets. Rebuild the landing snapshotter (offscreen WKWebView, rAF polyfill, finish animations) when it's needed.
- Owed after 3.0: simplify README.md and CLAUDE.md, redraw architecture.svg, and cut the commercial (joshuatree `docs/hardware/ad` style).

## Restart prompt

```
/loop Take Elah to 3.0 per docs/LOOP-HANDOFF.md and docs/roadmap.md: one minor per tick (2.3, 2.4, 2.5) to 3.0.0, each type-checked, QA'd with screenshot renders to A+, tagged, released and the landing deployed. Then README, CLAUDE.md, architecture.svg and the commercial.
```
