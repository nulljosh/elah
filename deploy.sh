#!/bin/sh
# Copy the brand files the landing shares with the repo, then deploy the Worker.
set -e
cd "$(dirname "$0")"
mkdir -p landing/fonts
cp brand/tokens.css brand/mark.svg icon.svg landing/
cp fonts/*.woff2 fonts/OFL.txt landing/fonts/
cp favicon.svg favicon-32.png apple-touch-icon.png landing/ 2>/dev/null || true
[ "$1" = "--copy-only" ] && exit 0
npx wrangler deploy
