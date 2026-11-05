#!/bin/sh
# Copy the brand files the landing shares with the repo, then deploy the Worker.
set -e
cd "$(dirname "$0")"
mkdir -p landing/fonts
cp brand/tokens.css brand/mark.svg icon.svg landing/
cp brand/tokens.css brand/icon-1024.png landing/brand/
cp fonts/*.woff2 fonts/OFL.txt landing/fonts/
mkdir -p landing/v && for v in kjv bsb asv nheb ylt darby webster bbe geneva; do cp app/Sources/Resources/$v.json landing/v/; done
cp favicon.svg favicon-32.png apple-touch-icon.png landing/ 2>/dev/null || true
[ "$1" = "--copy-only" ] && exit 0
npx wrangler deploy
