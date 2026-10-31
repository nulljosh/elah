"""Builds app/Sources/Resources/xrefs.json from OpenBible.info cross references (CC BY).
Usage: python3 scripts/gen_xrefs.py cross_references.txt
Keys and values are "book.chapter.verse" (book 0 based), the same keys Marks uses. Top 8 per verse by votes."""
import json, sys
from collections import defaultdict

BOOKS = ("Gen Exod Lev Num Deut Josh Judg Ruth 1Sam 2Sam 1Kgs 2Kgs 1Chr 2Chr Ezra Neh Esth Job Ps Prov Eccl Song "
         "Isa Jer Lam Ezek Dan Hos Joel Amos Obad Jonah Mic Nah Hab Zeph Hag Zech Mal Matt Mark Luke John Acts Rom "
         "1Cor 2Cor Gal Eph Phil Col 1Thess 2Thess 1Tim 2Tim Titus Phlm Heb Jas 1Pet 2Pet 1John 2John 3John Jude Rev").split()
IDX = {b: i for i, b in enumerate(BOOKS)}

def key(osis):
    b, c, v = osis.split("-")[0].split(".")
    return f"{IDX[b]}.{c}.{v}"

refs = defaultdict(list)
for line in open(sys.argv[1]).readlines()[1:]:
    src, dst, votes = line.rstrip("\n").split("\t")
    if int(votes) > 0:
        refs[key(src)].append((int(votes), key(dst)))
out = {k: [d for _, d in sorted(v, reverse=True)[:8]] for k, v in refs.items()}
json.dump(out, open("app/Sources/Resources/xrefs.json", "w"), separators=(",", ":"))
print(len(out), "verses")
