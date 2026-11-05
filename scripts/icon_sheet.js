// node render.js -> sheet.png: each variant at 1024 (shown 300), 87 and 29 px, light and dark tiles
const sharp = require('sharp'), fs = require('fs');
const L = ['#d99a22','#d0612f','#b8324f','#6a3fa8','#1745a8'], D = ['#f2c14e','#f28a52','#ef6b86','#a98af2','#6ea8ff'];
// arcs: [x1,x2] on a 1024 grid, coloured by span (short gold to long blue)
function arcs(list, base, w, pal, k=1){
  const sorted=[...list].sort((a,b)=>(b[1]-b[0])-(a[1]-a[0])); // longest first, so short ones sit on top
  // colour by rank of span, so five arcs take the five palette stops
  const n=sorted.length;
  return sorted.map(([a,b],i)=>{const r=(b-a)/2, c=pal[Math.round((n-1-i)/(n-1||1)*4)];
    return `<path d="M${a} ${base} A${r} ${r*k} 0 0 1 ${b} ${base}" fill="none" stroke="${c}" stroke-width="${w}" stroke-linecap="round"/>`}).join('');
}
const V = JSON.parse(fs.readFileSync(process.argv[2]||'variants.json'));
function tile(v, dark){
  const bg = dark ? `<linearGradient id="g" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#14254f"/><stop offset="1" stop-color="#070f24"/></linearGradient>` : `<linearGradient id="g" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#ffffff"/><stop offset="1" stop-color="#eef1f6"/></linearGradient>`;
  const bgv = v.bg ? (dark? v.bg[1]: v.bg[0]) : bg;
  return `<svg xmlns="http://www.w3.org/2000/svg" width="1024" height="1024" viewBox="0 0 1024 1024"><defs>${bgv}</defs><rect width="1024" height="1024" rx="224" fill="url(#g)"/>${(v.pre||'').replace(/INK/g, dark?'#f2f3f5':'#16181c')}${arcs(v.arcs, v.base, v.w, v.mono ? Array(5).fill(dark?v.mono[1]:v.mono[0]) : (dark?D:L), v.k||1)}${(v.post||'').replace(/INK/g, dark?'#f2f3f5':'#16181c')}</svg>`;
}
(async()=>{
  const rows=[]; let y=0; const W=300+20+87+20+29+40;
  for (const v of V){ for (const dark of [false,true]){
    const svg=Buffer.from(tile(v,dark)); fs.writeFileSync(`${v.id}-${dark?'d':'l'}.svg`, svg);
    const big=await sharp(svg).resize(300).png().toBuffer(), mid=await sharp(svg).resize(87).png().toBuffer(), sm=await sharp(svg).resize(29).png().toBuffer();
    rows.push({input:big,left:20+(dark?W:0),top:y+20},{input:mid,left:340+(dark?W:0),top:y+20},{input:sm,left:447+(dark?W:0),top:y+20});
  } y+=340; }
  await sharp({create:{width:W*2+20,height:y+20,channels:3,background:'#8a9099'}}).composite(rows).png().toFile('sheet.png');
  console.log('ok', V.length);
})();
