// Footer glyphs: the things of 1 Samuel 17 and the Psalms in a row (the book mark, David's sling, the five smooth
// stones, his harp, the crown, the lamp of Psalm 119:105), cut like a line engraving in plain 2D canvas. Faint rules
// run across the band; inside the glyphs they thicken, and thicken again on the edge facing away from the light, so the
// glyphs look cut into the page. Drawn once per size and theme. Same engine as the Hermes footer.
(function () {
  var band = document.querySelector('.glyph-band'), canvas = band && band.querySelector('canvas');
  if (!canvas) return;

  var mark = new Image(), tints = {};
  mark.src = 'mark.svg';

  // Each glyph is drawn white on a 100 unit square.
  var GLYPHS = [
    function (c) { // the book mark itself
      if (!mark.complete || !mark.naturalWidth) return;
      var key = c.fillStyle;
      if (!tints[key]) {
        var t = document.createElement('canvas'); t.width = t.height = 400;
        var tc = t.getContext('2d'); tc.drawImage(mark, 0, 0, 400, 400);
        tc.globalCompositeOperation = 'source-in'; tc.fillStyle = key; tc.fillRect(0, 0, 400, 400);
        tints[key] = t;
      }
      c.drawImage(tints[key], -8, -8, 116, 116);
    },
    function (c) { // sling: two cords from the hand loop to a pouch holding a stone
      c.lineWidth = 5; c.lineCap = 'round';
      c.beginPath(); c.arc(22, 20, 8, 0, 7); c.stroke();
      c.beginPath(); c.moveTo(26, 27); c.quadraticCurveTo(34, 62, 52, 76); c.stroke();
      c.beginPath(); c.moveTo(29, 25); c.quadraticCurveTo(62, 48, 80, 70); c.stroke();
      c.beginPath(); c.ellipse(66, 78, 18, 10, -0.5, 0, 7); c.fill();
    },
    function (c) { // five smooth stones
      [[24, 70, 15, 10, -0.2], [52, 74, 13, 9, 0.3], [76, 68, 12, 8, -0.4], [37, 48, 11, 8, 0.5], [63, 46, 10, 7, -0.1]]
        .forEach(function (s) { c.beginPath(); c.ellipse(s[0], s[1], s[2], s[3], s[4], 0, 7); c.fill(); });
    },
    function (c) { // David's harp: a curved frame, a pillar and strings
      c.lineWidth = 8; c.lineCap = 'round';
      c.beginPath(); c.moveTo(26, 88); c.quadraticCurveTo(18, 30, 52, 14); c.quadraticCurveTo(80, 6, 82, 30); c.stroke();
      c.beginPath(); c.moveTo(26, 88); c.lineTo(80, 88); c.stroke();
      c.beginPath(); c.moveTo(82, 30); c.lineTo(80, 88); c.stroke();
      c.lineWidth = 2.5;
      for (var i = 0; i < 6; i++) { var x = 34 + i * 8; c.beginPath(); c.moveTo(x, 86); c.lineTo(x, 26 - Math.sin(i / 5 * Math.PI) * 4 + i * 1.5); c.stroke(); }
    },
    function (c) { // crown
      c.beginPath(); c.moveTo(16, 76); c.lineTo(14, 32); c.lineTo(32, 52); c.lineTo(50, 24); c.lineTo(68, 52); c.lineTo(86, 32); c.lineTo(84, 76); c.closePath(); c.fill();
      c.beginPath(); c.roundRect(14, 78, 72, 10, 3); c.fill();
      [14, 50, 86].forEach(function (x, i) { c.beginPath(); c.arc(x, i === 1 ? 20 : 28, 5, 0, 7); c.fill(); });
    },
    function (c) { // oil lamp with its flame: thy word is a lamp unto my feet
      c.beginPath(); c.ellipse(46, 72, 34, 14, 0, 0, 7); c.fill();
      c.beginPath(); c.moveTo(70, 66); c.quadraticCurveTo(88, 60, 92, 52); c.lineTo(80, 72); c.closePath(); c.fill();
      c.lineWidth = 6; c.beginPath(); c.arc(14, 70, 8, Math.PI * 0.5, Math.PI * 1.5); c.stroke();
      c.beginPath(); c.moveTo(90, 50); c.quadraticCurveTo(80, 34, 90, 18); c.quadraticCurveTo(100, 34, 90, 50); c.fill();
    }
  ];
  // Lays the glyphs out evenly across a w by h 2D context, in the given colour: one row, or two on a narrow band.
  function grid(w, h) {
    var n = GLYPHS.length, rows = w < h * 3 ? 2 : 1, per = Math.ceil(n / rows);
    return { rows: rows, per: per, cell: Math.min(h / rows * 0.86, w / per) };
  }
  function paint(c, w, h, colour) {
    var g = grid(w, h), gap = (w - g.cell * g.per) / g.per, rowH = h / g.rows;
    GLYPHS.forEach(function (draw, i) {
      var col = i % g.per, row = Math.floor(i / g.per);
      c.save(); c.translate(gap / 2 + col * (g.cell + gap), row * rowH + (rowH - g.cell) / 2 + rowH * 0.04); c.scale(g.cell / 100, g.cell / 100);
      c.fillStyle = c.strokeStyle = colour; draw(c); c.restore();
    });
  }

  var ctx = canvas.getContext('2d');
  if (!ctx) return;
  function layer(w, h) { var c = document.createElement('canvas'); c.width = w; c.height = h; return c; }
  // Horizontal rules `t` px thick, one every `pitch` px, kept only where `mask` is drawn (everywhere when null).
  function rules(w, h, pitch, t, colour, mask) {
    var c = layer(w, h), x = c.getContext('2d');
    x.fillStyle = colour;
    for (var y = 0; y < h; y += pitch) x.fillRect(0, Math.round(y + (pitch - t) / 2), w, Math.max(1, Math.round(t)));
    if (mask) { x.globalCompositeOperation = 'destination-in'; x.drawImage(mask, 0, 0); }
    return c;
  }
  var drawnW = 0;
  function draw() {
    var dpr = Math.min(window.devicePixelRatio || 1, 2), w = Math.round(canvas.clientWidth * dpr), h = Math.round(canvas.clientHeight * dpr);
    if (!w || !h) return;
    drawnW = w; canvas.width = w; canvas.height = h;
    var colour = getComputedStyle(band).color, pitch = Math.min(5 * dpr, Math.max(3 * dpr, grid(w, h).cell / 22)), s = Math.max(2, h * 0.014);
    var glyphs = layer(w, h); paint(glyphs.getContext('2d'), w, h, '#fff');
    // the shadow side: glyph pixels whose neighbour down and right is outside the glyph (light from the top left)
    var shade = layer(w, h), sc = shade.getContext('2d');
    sc.drawImage(glyphs, 0, 0); sc.globalCompositeOperation = 'destination-out'; sc.drawImage(glyphs, -s, -s);
    ctx.globalAlpha = 0.28; ctx.drawImage(rules(w, h, pitch, dpr * 0.75, colour, null), 0, 0);
    ctx.globalAlpha = 1; ctx.drawImage(rules(w, h, pitch, pitch * 0.32, colour, glyphs), 0, 0);
    ctx.drawImage(rules(w, h, pitch, pitch * 0.6, colour, shade), 0, 0);
  }
  band.classList.add('live');
  draw();
  mark.addEventListener('load', draw);
  // iOS fires resize as the toolbar slides; only a width change needs a redraw
  window.addEventListener('resize', function () { if (Math.round(canvas.clientWidth * Math.min(window.devicePixelRatio || 1, 2)) !== drawnW) draw(); });
  matchMedia('(prefers-color-scheme: dark)').addEventListener('change', draw);
})();
