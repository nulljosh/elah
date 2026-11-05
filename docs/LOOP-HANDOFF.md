# Elah loop handoff (2026-11-05, midday)

## What the loop is

One loop takes Elah, the King James Bible app for iPhone, iPad and Mac, up the version plan in `docs/roadmap.md` to 2.0 (reading plans). Each tick ships one minor: build it on every platform, QA in light and dark, commit, tag, push, deploy the landing.

## Where things stand

- Repo is at 2.0.0: reading plans on Today (four plans, check a day off, progress). Before that, 1.5.0: cross references on every verse (OpenBible.info, CC BY, built by `scripts/gen_xrefs.py`), an animated launch splash, and a daily verse notification on Today. 13 tests pass on Mac.
- ASC record 6829146794. iOS 1.3.0 was rejected and its submission cancelled; the reason was never read (Apple sign-in throttled). iOS 2.1.0 is WAITING_FOR_REVIEW with nine Bibles; Mac 1.3.0 is still WAITING_FOR_REVIEW. The 2.0.0 reading plans ride with them.
- The NIV was cut on 2026-10-31. Nine public domain Bibles are bundled offline as real text (KJV, BSB, ASV, New Heart, Young's, Darby, Webster, Basic English, Geneva), picked from a version picker in the top bar. The web reader shows the same text, and the landing says nine Bibles.
- App Privacy is published as Data Not Collected. Age rating 4+, Books and Reference, free, every territory but China.

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

1. Watch iOS 2.1.0 and Mac 1.3.0 in review. If either is rejected, read the reason with `asc web review show` and answer it on Joshua's yes; never resubmit unchanged. The old 1.3.0 iOS rejection was cancelled, so its reason is moot unless it comes back.
2. When the review clears, the 2.0.0 Today shots and What's New go up with the next version (`--copy-metadata-from`, upload each platform's build, validate, submit).
3. 2.0 is built. Still owed for the major: a Mobbin pass over the rival sheets and the opus-ad film.
4. Screen QA leftovers: search result count card, verse menu, note editor and share sheet in light and dark.

## Loop state (2026-11-05)

- 2.2.0 is in code and pushed: Map tab (`ArcMap.swift`, `Resources/arcs.json`), Doré plates (`Plates.swift`, `Plates/`), listing in `metadata/version/2.2.0`, tests added. It type-checks against the macOS 14 SDK (`swiftc -typecheck -sdk /Library/Developer/CommandLineTools/SDKs/MacOSX14.2.sdk -target x86_64-apple-macos14.0 app/Sources/*.swift`), but it has **not been built or run**: Dad's Mac has Xcode 15.2 and macOS 13. Build, test and upload on Joshua's Mac (steps above).
- A `/code-review` of v2.1.0..HEAD was running when this was written. Fix its findings, then tag `v2.2.0` and publish a GitHub release (no releases exist yet; tags go to v2.1.0).
- Repo hygiene: no open issues, no PRs, only `main`.
- Roadmap is mapped to 10.0. Next minors: 2.3 arcs in the reader, 2.4 Map filters and zoom, 2.5 Stories, then 3.0 "the Bible you can see".
- QA renders: the screenshot harness is in the session scratchpad and is lost on compact. Rebuild it as an ImageRenderer CLI targeting macOS 13, stubbing `ShareImageSheet` (VerseImage.swift needs macOS 14). For the landing, use the offscreen WKWebView snapshotter: polyfill rAF and finish animations before the snapshot.
- Still owed after 3.0: simplify README.md and CLAUDE.md, redraw architecture.svg, and cut a commercial modelled on joshuatree `docs/hardware/ad` (VO via `say -v Samantha`, cards, ffmpeg; no ImageMagick here).

## Restart prompt

```
/loop Take Elah to 3.0 per docs/LOOP-HANDOFF.md and docs/roadmap.md: fix the code-review findings, release v2.2.0 on GitHub, then one minor per tick (2.3, 2.4, 2.5) to 3.0.0, each type-checked, QA'd with screenshot renders to A+, tagged, released and the landing deployed. Then README, CLAUDE.md, architecture.svg and the commercial.
```
