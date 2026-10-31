# Elah loop handoff (2026-10-31, just after midnight)

## What the loop is

One loop takes Elah, the King James Bible app for iPhone, iPad and Mac, up the version plan in `docs/roadmap.md` to 2.0 (reading plans). Each tick ships one minor: build it on every platform, QA in light and dark, commit, tag, push, deploy the landing.

## Where things stand

- Repo is at 1.5.0: cross references on every verse (OpenBible.info, CC BY, built by `scripts/gen_xrefs.py`), an animated launch splash, and a daily verse notification on Today. 12 tests pass on Mac.
- ASC record 6829146794. iOS 1.3.0 and Mac 1.3.0 are both WAITING_FOR_REVIEW (submitted 2026-10-30). Listing has Bible, Search and Saved shots per device; the retaken Today shots are in `screenshots/` and go up with the next version.
- iOS build for 1.4.0 is uploaded, unattached. A new version can only be created once 1.3.0 clears review.
- App Privacy is published as Data Not Collected. Age rating 4+, Books and Reference, free, every territory but China.

## Next, in order

1. When 1.3.0 is approved, create version 1.5.0 on iOS and Mac with `--copy-metadata-from 1.3.0`, upload a 1.5.0 build of each (`asc workflow run upload-ios`, Mac via xcodebuild archive and export with `app/MacExportOptions.plist`), add the Today shots, What's New, then validate and submit.
2. If review rejects, read the reason with `asc web review show` and answer it; never resubmit unchanged.
3. 2.0 reading plans: start a plan, today's chapters on Today, check them off, progress. A major needs a Mobbin pass over `scratchpad/comp` sheets and the opus-ad film.
4. Screen QA leftovers: search result count card, verse menu, note editor, share sheet and NIV sheet in light and dark.

## Restart prompt

```
/loop Elah to v2.0.0: ship 1.5 to the store once 1.3.0 clears review, then build 2.0 (reading plans) per docs/roadmap.md and docs/LOOP-HANDOFF.md. Each tick one minor, QA light and dark, commit, tag, push, deploy.
```
