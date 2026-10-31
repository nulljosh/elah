# Bible loop handoff (2026-10-30, night)

## What the loop is

The loop builds the Bible roadmap in `docs/roadmap.md` one version at a time, starting with the next open version (0.4). Each version closes the rows it names in the parity and gap matrices, ships on iPhone, iPad, Mac and the web page together, and refreshes both matrices. A feature is a minor and a fix is a patch. 1.0 is the first major and is Joshua's call, so the loop stops at 0.9 and waits for his yes before cutting 1.0. Versions are NIV and KJV only. No accounts, analytics or ads.

QA: unit tests with `cd app && xcodegen generate && xcodebuild -scheme Bible -destination 'platform=macOS' test`. The web page gets a headless check at 390px in light and dark. The NIV opens BibleGateway in a Safari sheet, never an embedded web view. No GUI launches on Joshua's screen without asking.

## Where things stand

- Repo at 0.3.0: native SwiftUI app for iPhone, iPad and Mac (bundle `com.nulljosh.bible`), KJV bundled and readable offline, NIV in a Safari sheet, 4 tests pass, iOS archive signed. Pushed, and the privacy and support pages are live at bible.jaybulb.com/privacy and /support.
- The web page opens on David and Goliath (1 Samuel 17, NIV) and frames BibleGateway.
- The App Store record is not created. It needs Joshua's Apple web login (`asc web auth login`). Plain "Bible" is taken on the store. Elah (the valley where David met Goliath) is the proposed name, not probed or locked.
- No iOS or Mac build is uploaded yet, and there are no store screenshots.

## Next, in order

1. Joshua runs `asc web auth login`. That is his step; never type his password or code.
2. Probe and lock the name with the asc-name-creator skill. Elah is the candidate.
3. Create the app record with `asc web apps create`, and drop China from availability.
4. Upload the iOS and Mac builds.
5. Store screenshots, light and dark, same framing.
6. `asc validate`, then submit on Joshua's yes.
7. Then the loop picks up 0.4 verse actions (highlight in four colours, copy, share, bookmark), then 0.5 onward, one version at a time.

## Restart prompt

```
/loop until v1.0.0. Build out roadmap to v10. Bible loop, in ~/Documents/Code/bible. Read docs/LOOP-HANDOFF.md first, then take the next open version in docs/roadmap.md (0.4 first). Each version closes the rows it names, ships on iPhone, iPad, Mac and the web page together, and refreshes both matrices. Features are minors, fixes are patches. 1.0 is a major and waits for Joshua's yes, so stop at 0.9 and ask before cutting it. NIV and KJV only, no accounts, analytics or ads. Skip any step that needs Joshua's Apple login. No GUI launches on Joshua's screen without asking. Commit by exact path and push. Deploy the web with ./deploy.sh only when the landing changed. Replies under 2 lines, plain English.
```
