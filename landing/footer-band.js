// Footer band: the Bible's cross-references as arcs, after Chris Harrison and Christoph Römhild's 2007 chart.
// Every bar along the bottom is a chapter, Genesis on the left to Revelation on the right, as tall as its verse count.
// Every arc joins two chapters that cite each other (OpenBible.info cross-references, CC BY, top 7,000 chapter pairs),
// coloured by how far it reaches: --arc-1 (ochre) for neighbours through --arc-5 (Elah blue) across the whole Bible.
// Cut like a line engraving: the colour is kept only on fine horizontal rules.
(function () {
  var band = document.querySelector('.arc-band'), canvas = band && band.querySelector('canvas');
  if (!canvas) return;
  var ctx = canvas.getContext('2d'), data = null, drawnW = 0;
  function layer(w, h) { var c = document.createElement('canvas'); c.width = w; c.height = h; return c; }
  function rgb(hex) { hex = hex.trim().replace('#', ''); if (hex.length === 3) hex = hex.replace(/./g, '$&$&'); var n = parseInt(hex, 16); return [n >> 16 & 255, n >> 8 & 255, n & 255]; }
  function ramp(stops, t) {  // t in 0..1 across the stops
    var f = Math.min(stops.length - 1.0001, Math.max(0, t) * (stops.length - 1)), i = Math.floor(f), u = f - i, a = stops[i], b = stops[i + 1];
    return 'rgb(' + [0, 1, 2].map(function (k) { return Math.round(a[k] + (b[k] - a[k]) * u); }).join(',') + ')';
  }
  function draw() {
    if (!data) return;
    var dpr = Math.min(window.devicePixelRatio || 1, 2), w = Math.round(canvas.clientWidth * dpr), h = Math.round(canvas.clientHeight * dpr);
    if (!w || !h) return;
    drawnW = w; canvas.width = w; canvas.height = h;
    var css = getComputedStyle(band), stops = [1, 2, 3, 4, 5].map(function (i) { return rgb(css.getPropertyValue('--arc-' + i) || '#1745a8'); });
    var n = data.verses.length, pad = 8 * dpr, step = (w - 2 * pad) / n;
    var base = h * 0.84, barMax = h * 0.14, maxV = Math.max.apply(null, data.verses);
    var art = layer(w, h), a = art.getContext('2d');
    var maxW = data.arcs[0][2], k = base * 0.96 / ((w - 2 * pad) / 2);  // one ratio for every arc, so the widest just fits
    // longest first, so the short warm arcs sit on top of the long blue ones
    data.arcs.slice().sort(function (p, q) { return (q[1] - q[0]) - (p[1] - p[0]); }).forEach(function (r) {
      var x0 = pad + (r[0] + 0.5) * step, x1 = pad + (r[1] + 0.5) * step, rx = (x1 - x0) / 2;
      a.strokeStyle = ramp(stops, Math.pow((r[1] - r[0]) / (n - 1), 0.45));
      a.globalAlpha = 0.35 + 0.65 * Math.sqrt(r[2] / maxW);
      a.lineWidth = Math.max(0.7, dpr * 0.9);
      a.beginPath(); a.ellipse(x0 + rx, base, rx, rx * k, 0, Math.PI, 0); a.stroke();
    });
    // bars: one per chapter, hanging below the baseline by verse count, in the colour of where it sits in the canon
    a.globalAlpha = 0.9;
    data.verses.forEach(function (v, i) { a.fillStyle = ramp(stops, i / (n - 1)); a.fillRect(pad + i * step, base + 2 * dpr, Math.max(1, step * 0.8), barMax * v / maxV); });
    // the engraving: keep the colour only on rules one every `pitch` px
    var pitch = 3 * dpr, t = Math.max(1, Math.round(pitch * 0.6)), cut = layer(w, h), c = cut.getContext('2d');
    c.fillStyle = '#000';
    for (var y = 0; y < h; y += pitch) c.fillRect(0, Math.round(y + (pitch - t) / 2), w, t);
    a.globalAlpha = 1; a.globalCompositeOperation = 'destination-in'; a.drawImage(cut, 0, 0);
    ctx.clearRect(0, 0, w, h); ctx.drawImage(art, 0, 0);
  }
  band.classList.add('live');
  fetch('xrefs.json').then(function (r) { return r.json(); }).then(function (d) { data = d; draw(); });
  window.addEventListener('resize', function () { if (Math.round(canvas.clientWidth * Math.min(window.devicePixelRatio || 1, 2)) !== drawnW) draw(); });
  matchMedia('(prefers-color-scheme: dark)').addEventListener('change', draw);
})();
