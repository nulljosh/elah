// Footer band: the Bible's cross-references as arcs, after Chris Harrison and Christoph Römhild's 2007 chart.
// Every bar along the bottom is a chapter, Genesis on the left to Revelation on the right, as tall as its verse count.
// Every arc joins two chapters that cite each other (OpenBible.info cross-references, CC BY, top 7,000 chapter pairs).
// Cut like a line engraving: the drawing is kept only on fine horizontal rules, the same engine as the Hermes footer.
(function () {
  var band = document.querySelector('.arc-band'), canvas = band && band.querySelector('canvas');
  if (!canvas) return;
  var ctx = canvas.getContext('2d'), data = null, drawnW = 0;
  function layer(w, h) { var c = document.createElement('canvas'); c.width = w; c.height = h; return c; }
  // Horizontal rules `t` px thick, one every `pitch` px, kept only where `mask` is drawn (everywhere when null).
  function rules(w, h, pitch, t, colour, mask) {
    var c = layer(w, h), x = c.getContext('2d');
    x.fillStyle = colour;
    for (var y = 0; y < h; y += pitch) x.fillRect(0, Math.round(y + (pitch - t) / 2), w, Math.max(1, Math.round(t)));
    if (mask) { x.globalCompositeOperation = 'destination-in'; x.drawImage(mask, 0, 0); }
    return c;
  }
  function draw() {
    if (!data) return;
    var dpr = Math.min(window.devicePixelRatio || 1, 2), w = Math.round(canvas.clientWidth * dpr), h = Math.round(canvas.clientHeight * dpr);
    if (!w || !h) return;
    drawnW = w; canvas.width = w; canvas.height = h;
    var colour = getComputedStyle(band).color, n = data.verses.length, pad = 8 * dpr, step = (w - 2 * pad) / n;
    var base = h * 0.84, barMax = h * 0.14, maxV = Math.max.apply(null, data.verses);
    var art = layer(w, h), a = art.getContext('2d');
    a.strokeStyle = a.fillStyle = '#fff';
    // arcs: half ellipses above the baseline, the long ones tallest; stronger links drawn bolder
    var maxW = data.arcs[0][2], k = base * 0.96 / ((w - 2 * pad) / 2);  // one ratio for every arc, so the widest just fits
    data.arcs.forEach(function (r) {
      var x0 = pad + (r[0] + 0.5) * step, x1 = pad + (r[1] + 0.5) * step, rx = (x1 - x0) / 2;
      a.globalAlpha = 0.18 + 0.82 * Math.sqrt(r[2] / maxW);
      a.lineWidth = Math.max(0.6, dpr * 0.8);
      a.beginPath(); a.ellipse(x0 + rx, base, rx, rx * k, 0, Math.PI, 0); a.stroke();
    });
    // bars: one per chapter, hanging below the baseline by verse count
    a.globalAlpha = 1;
    data.verses.forEach(function (v, i) { a.fillRect(pad + i * step, base + 2 * dpr, Math.max(1, step * 0.8), barMax * v / maxV); });
    var pitch = Math.max(2 * dpr, 3 * dpr);
    ctx.clearRect(0, 0, w, h);
    ctx.globalAlpha = 0.22; ctx.drawImage(rules(w, h, pitch, dpr * 0.6, colour, null), 0, 0);
    ctx.globalAlpha = 1; ctx.drawImage(rules(w, h, pitch, pitch * 0.55, colour, art), 0, 0);
  }
  band.classList.add('live');
  fetch('xrefs.json').then(function (r) { return r.json(); }).then(function (d) { data = d; draw(); });
  window.addEventListener('resize', function () { if (Math.round(canvas.clientWidth * Math.min(window.devicePixelRatio || 1, 2)) !== drawnW) draw(); });
  matchMedia('(prefers-color-scheme: dark)').addEventListener('change', draw);
})();
