# Elah loop handoff (2026-10-30, near midnight)

## What the loop is

Two loops are live. One takes every screen of Elah, the King James Bible app for iPhone, iPad and Mac, to A+. The other finishes the first App Store submission. The repo is nulljosh/elah in ~/Documents/Code/elah. It was renamed from Bible tonight because Bible is taken on the store.

## Where things stand

- App 1.3.0: Today, Bible, Search and Saved tabs, a listening bar, highlights, notes, a share card and the Elah Sans font. 10 tests pass on Mac.
- ASC record 6829146794 is named Elah (iOS). Version 1.3.0 is in PREPARE_FOR_SUBMISSION.
- Build 202610310200 is uploaded through `asc workflow run upload-ios`.
- The en-US listing text is pushed from `metadata/`.
- Store screenshots are in `screenshots/iphone` (1320x2868) and `screenshots/ipad` (2064x2752), not yet uploaded.
- The landing is at elah.jaybulb.com (bible.jaybulb.com still serves): Doré art, Bible characters through the page and the cross-reference arc footer.
- The Apple web session was authenticated at 23:30. If it expires, run `asc web auth login --two-factor-method sms` with a code command, and Joshua sends the SMS code.

## Next, in order

1. Upload the store screenshots: `asc screenshots upload` for IPHONE_69 and IPAD_PRO_3GEN_129.
2. Set the age rating (4+, no objectionable content), the content rights declaration (the KJV is public domain), the primary category Books and secondary Reference, the price (free), and availability in every territory except China.
3. Publish App Privacy as Data Not Collected (`asc web privacy`), then attach build 202610310200 to 1.3.0.
4. Run `asc validate --app 6829146794 --version 1.3.0`, fix what it lists, then submit.
5. Add macOS to the record and ship the Mac build (`app/MacExportOptions.plist`, like Eponym's ship-mac).
6. Screen QA fixes:
   - Search: the result count shows as its own white card; fold it into the list header.
   - iPad reader and Today: the column sits left of centre with a large empty right side.
   - Shoot and check the verse menu, the note editor, the share sheet and the NIV Safari sheet in light and dark.
7. Then 1.4: cross-references in the app, verse level, from OpenBible (CC BY).

## Restart prompt

```
/loop until every screen is a+. Then finish the Elah App Store submission per docs/LOOP-HANDOFF.md.
```
