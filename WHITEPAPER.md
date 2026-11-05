# Elah Technical Whitepaper

**v0.2.0** | October 2026

Elah (first called Bible) is a reader that opens on David and Goliath, 1 Samuel 17 in the NIV, and reads any passage in the NIV or the King James. It stores nothing, asks for no account and runs no server of its own. The text, the verse parsing and the licence for the NIV all come from BibleGateway, which the page shows in a frame.

## The core idea: a passage is a URL

BibleGateway turns a reference and a version into a page at one address: `https://www.biblegateway.com/passage/?search=<reference>&version=<version>`. The whole app builds that address and sets it as the source of a frame. Typing `Psalm 23` and choosing KJV sets the source to `search=Psalm%2023&version=KJV`. BibleGateway reads "1 Sam 17", "1 Samuel 17:45-47" and "John 3:16" the same way, so the app has no book list, no verse parser and no text of its own to get wrong.

The reference goes through `encodeURIComponent`, so what you type can never change the host or add a parameter. The version comes from a two-item picker, never from free text.

## Why a frame works

A page can only sit in a frame if the other site allows it. BibleGateway sends no `X-Frame-Options` and no `frame-ancestors` policy (checked 2026-10-30), so it does. That is the one fragile joint. If they add the header the frame goes blank, and the fallback in the roadmap is an own-text source: the King James from public domain files first, the NIV only under a licence from Biblica.

## Home

The home button sets the box to `1 Samuel 17`, the picker to NIV and loads it, and the page opens there on every visit. Nothing is remembered between visits yet. Resume is on the roadmap and will not move the home.

## Design

One accent, a deep royal blue, on warm paper in light and warm graphite in dark. Controls are 48 point capsules on an 8 point grid, set in the system font. `brand/tokens.css` is the single source and `deploy.sh` copies it into `landing/`. The icon is an open book with a ribbon marker, built as an Icon Composer bundle.

## What it leaves out

No accounts, no analytics, no ads, no verse-of-the-day feed, no other translations. Each is a row on the roadmap or a deliberate skip, and the page stays one file until a row earns more.

Apache 2.0, 2026 Joshua Trommel.
