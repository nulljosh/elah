# Elah loop handoff (2026-10-31, evening)

## What the loop is

One loop takes Elah, the King James Bible app for iPhone, iPad and Mac, up the version plan in `docs/roadmap.md` to 2.0 (reading plans). Each tick ships one minor: build it on every platform, QA in light and dark, commit, tag, push, deploy the landing.

## Where things stand

- Repo is at 2.0.0: reading plans on Today (four plans, check a day off, progress). Before that, 1.5.0: cross references on every verse (OpenBible.info, CC BY, built by `scripts/gen_xrefs.py`), an animated launch splash, and a daily verse notification on Today. 13 tests pass on Mac.
- ASC record 6829146794. iOS 1.3.0 was rejected and its submission cancelled; the reason was never read (Apple sign-in throttled). iOS 2.1.0 is WAITING_FOR_REVIEW with nine Bibles; Mac 1.3.0 is still WAITING_FOR_REVIEW. The 2.0.0 reading plans ride with them.
- The NIV was cut on 2026-10-31. Nine public domain Bibles are bundled offline as real text (KJV, BSB, ASV, New Heart, Young's, Darby, Webster, Basic English, Geneva), picked from a version picker in the top bar. The web reader shows the same text, and the landing says nine Bibles.
- App Privacy is published as Data Not Collected. Age rating 4+, Books and Reference, free, every territory but China.

## Next, in order

1. Watch iOS 2.1.0 and Mac 1.3.0 in review. If either is rejected, read the reason with `asc web review show` and answer it on Joshua's yes; never resubmit unchanged. The old 1.3.0 iOS rejection was cancelled, so its reason is moot unless it comes back.
2. When the review clears, the 2.0.0 Today shots and What's New go up with the next version (`--copy-metadata-from`, upload each platform's build, validate, submit).
3. 2.0 is built. Still owed for the major: a Mobbin pass over the rival sheets and the opus-ad film.
4. Screen QA leftovers: search result count card, verse menu, note editor and share sheet in light and dark.

## Restart prompt

```
/loop Ship Elah 2.0.0 to the App Store on iPhone, iPad and Mac once iOS 2.1.0 and Mac 1.3.0 clear review, per docs/LOOP-HANDOFF.md. Then the Mobbin pass and the opus-ad film for the 2.0 major.
```
