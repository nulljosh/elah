// Draws the Elah icon, five cross-reference arcs on one line coloured by reach on a night navy tile,
// and writes every copy of it. Run: NODE_PATH=<a node_modules with sharp> node scripts/gen_icon.js
const sharp = require('sharp'), fs = require('fs');
const spans = [[144, 880], [144, 624], [400, 880], [272, 528], [656, 816]];   // longest first, as ArcMark.spans
const pal = ['#6ea8ff', '#a98af2', '#ef6b86', '#f28a52', '#f2c14e'];             // the dark arc palette, far to near
const base = 696, w = 58;
const arcs = spans.map(([a, b], i) => `<path d="M${a} ${base} A${(b - a) / 2} ${(b - a) / 2} 0 0 1 ${b} ${base}" fill="none" stroke="${pal[i]}" stroke-width="${w}" stroke-linecap="round"/>`).join('');
const grad = `<linearGradient id="g" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#14254f"/><stop offset="1" stop-color="#070f24"/></linearGradient>`;
const tile = (rx, size = 1024) => `<svg xmlns="http://www.w3.org/2000/svg" width="${size}" height="${size}" viewBox="0 0 1024 1024"><defs>${grad}</defs><rect width="1024" height="1024" rx="${rx}" fill="url(#g)"/>${arcs}</svg>`;
const mark = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024">${arcs}</svg>`;
const out = (p, s) => fs.writeFileSync(p, s + '\n');
out('brand/mark.svg', mark); out('brand/icon-tile.svg', tile(0));
out('icon.svg', tile(224, 200)); out('landing/icon.svg', tile(224, 200)); out('landing/favicon.svg', tile(224, 64));
(async () => {
  await sharp(Buffer.from(mark)).png().toFile('Bible.icon/Assets/glyph.png');
  await sharp(Buffer.from(tile(0))).flatten().removeAlpha().png().toFile('brand/icon-1024.png');
  fs.copyFileSync('brand/icon-1024.png', 'landing/brand/icon-1024.png');
  await sharp(Buffer.from(tile(0))).resize(180).flatten().removeAlpha().png().toFile('landing/apple-touch-icon.png');
  await sharp(Buffer.from(tile(224))).resize(32).png().toFile('landing/favicon-32.png');
  console.log('icon written');
})();
