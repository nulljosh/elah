// Hero wall: Elah's reader behind the copy. Real King James passages (from the app's own kjv.json, the same text it
// ships offline), each card reading aloud verse by verse with the reader's highlight, then turning to the next.
(function () {
  var wall = document.getElementById('ewall'); if (!wall) return;
  var still = matchMedia('(prefers-reduced-motion: reduce)').matches;
  var n = innerWidth <= 560 ? 4 : innerWidth <= 900 ? 6 : 9;
  var PASSAGES = [["1 Samuel 17", 45, ["Then said David to the Philistine, Thou comest to me with a sword, and with a spear, and with a shield: but I come to thee in the name of the LORD of hosts, the God of the armies of Israel, whom thou hast defied.", "This day will the LORD deliver thee into mine hand; and I will smite thee, and take thine head from thee; and I will give the carcases of the host of the Philistines this day unto the fowls of the air, and to the wild beasts of the earth; that all the earth may know that there is a God in Israel.", "And all this assembly shall know that the LORD saveth not with sword and spear: for the battle is the LORD’s, and he will give you into our hands."]], ["Genesis 1", 1, ["In the beginning God created the heaven and the earth.", "And the earth was without form, and void; and darkness was upon the face of the deep. And the Spirit of God moved upon the face of the waters.", "And God said, Let there be light: and there was light."]], ["Psalms 23", 1, ["The LORD is my shepherd; I shall not want.", "He maketh me to lie down in green pastures: he leadeth me beside the still waters.", "He restoreth my soul: he leadeth me in the paths of righteousness for his name’s sake.", "Yea, though I walk through the valley of the shadow of death, I will fear no evil: for thou art with me; thy rod and thy staff they comfort me."]], ["John 1", 1, ["In the beginning was the Word, and the Word was with God, and the Word was God.", "The same was in the beginning with God.", "All things were made by him; and without him was not any thing made that was made.", "In him was life; and the life was the light of men."]], ["Ecclesiastes 3", 1, ["To every thing there is a season, and a time to every purpose under the heaven:", "A time to be born, and a time to die; a time to plant, and a time to pluck up that which is planted;", "A time to kill, and a time to heal; a time to break down, and a time to build up;", "A time to weep, and a time to laugh; a time to mourn, and a time to dance;"]], ["Isaiah 40", 28, ["Hast thou not known? hast thou not heard, that the everlasting God, the LORD, the Creator of the ends of the earth, fainteth not, neither is weary? there is no searching of his understanding.", "He giveth power to the faint; and to them that have no might he increaseth strength.", "Even the youths shall faint and be weary, and the young men shall utterly fall:", "But they that wait upon the LORD shall renew their strength; they shall mount up with wings as eagles; they shall run, and not be weary; and they shall walk, and not faint."]], ["Matthew 5", 3, ["Blessed are the poor in spirit: for theirs is the kingdom of heaven.", "Blessed are they that mourn: for they shall be comforted.", "Blessed are the meek: for they shall inherit the earth.", "Blessed are they which do hunger and thirst after righteousness: for they shall be filled.", "Blessed are the merciful: for they shall obtain mercy."]], ["Romans 8", 38, ["For I am persuaded, that neither death, nor life, nor angels, nor principalities, nor powers, nor things present, nor things to come,", "Nor height, nor depth, nor any other creature, shall be able to separate us from the love of God, which is in Christ Jesus our Lord."]], ["1 Corinthians 13", 4, ["Charity suffereth long, and is kind; charity envieth not; charity vaunteth not itself, is not puffed up,", "Doth not behave itself unseemly, seeketh not her own, is not easily provoked, thinketh no evil;", "Rejoiceth not in iniquity, but rejoiceth in the truth;", "Beareth all things, believeth all things, hopeth all things, endureth all things."]], ["Proverbs 3", 5, ["Trust in the LORD with all thine heart; and lean not unto thine own understanding.", "In all thy ways acknowledge him, and he shall direct thy paths.", "Be not wise in thine own eyes: fear the LORD, and depart from evil."]], ["Micah 6", 8, ["He hath shewed thee, O man, what is good; and what doth the LORD require of thee, but to do justly, and to love mercy, and to walk humbly with thy God?"]], ["Revelation 21", 4, ["And God shall wipe away all tears from their eyes; and there shall be no more death, neither sorrow, nor crying, neither shall there be any more pain: for the former things are passed away.", "And he that sat upon the throne said, Behold, I make all things new. And he said unto me, Write: for these words are true and faithful."]]];
  var el = function (t, c, x) { var e = document.createElement(t); if (c) e.className = c; if (x != null) e.textContent = x; return e; };
  var wait = function (ms) { return new Promise(function (r) { setTimeout(r, still ? 0 : ms); }); };
  for (var i = 0; i < n; i++) (function (i) {
    var a = wall.appendChild(el('article', 'ec')), hd = a.appendChild(el('div', 'ec-hd')), ref = hd.appendChild(el('b')), tr = hd.appendChild(el('span', '', 'KJV'));
    var body = a.appendChild(el('p', 'ec-txt')), k = i;
    function play() {
      var p = PASSAGES[k % PASSAGES.length]; k += n;
      ref.textContent = p[0] + ':' + p[1] + (p[2].length > 1 ? '–' + (p[1] + p[2].length - 1) : '');
      body.textContent = '';
      var spans = p[2].map(function (v, j) { var s = el('span'); s.appendChild(el('sup', '', String(p[1] + j))); s.appendChild(document.createTextNode(v + ' ')); body.appendChild(s); return s; });
      if (still) return Promise.resolve();
      return spans.reduce(function (q, s) { return q.then(function () { s.classList.add('on'); return wait(Math.min(5200, 1400 + s.textContent.length * 22)); })
        .then(function () { s.classList.remove('on'); }); }, wait(400)).then(function () { return wait(900); });
    }
    if (still) play(); else wait(i * 300).then(function loop() { return play().then(loop); });
  })(i);
})();

// Hero parallax: the wall drifts at 0.45, the copy lifts at 0.2 and fades. Off under reduced motion.
(function () {
  var bg = document.querySelector('.hero-bg'), copy = document.querySelector('.hero-copy');
  if (!bg || matchMedia('(prefers-reduced-motion: reduce)').matches) return;
  var t = 0;
  addEventListener('scroll', function () {
    if (t) return;
    t = requestAnimationFrame(function () {
      t = 0; var y = scrollY, h = innerHeight; if (y > h * 1.2) return;
      bg.style.setProperty('--py', (y * .45) + 'px');
      copy.style.transform = 'translate3d(0,' + (y * .2) + 'px,0)'; copy.style.opacity = Math.max(0, 1 - y / (h * .7));
    });
  }, { passive: true });
})();
