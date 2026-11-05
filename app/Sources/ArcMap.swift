import SwiftUI

/// The Bible's cross references as one picture, after Chris Harrison and Christoph Römhild (2007): every chapter is a bar
/// along the bottom, Genesis to Revelation, and every arc joins two chapters that cite each other. Tap or drag along the
/// chapters to light one up, then open any chapter it reaches. Data: OpenBible.info cross references (CC BY), the top
/// 7,000 chapter pairs by votes (Resources/arcs.json, the same file the landing footer draws).
final class ArcMap {
    static let shared = ArcMap()
    let verses: [Int]
    let arcs: [Arc]
    private let starts: [Int]
    private let byChapter: [Int: [Arc]]

    struct Arc: Hashable { let a: Int, b: Int, weight: Int; var span: Int { b - a } }

    init(bible: Bible = .shared) {
        struct File: Decodable { let verses: [Int]; let arcs: [[Int]] }
        let file = Bundle.main.url(forResource: "arcs", withExtension: "json").flatMap { try? Data(contentsOf: $0) }
            .flatMap { try? JSONDecoder().decode(File.self, from: $0) }
        verses = file?.verses ?? []
        arcs = (file?.arcs ?? []).compactMap { $0.count == 3 ? Arc(a: min($0[0], $0[1]), b: max($0[0], $0[1]), weight: $0[2]) : nil }
        var s: [Int] = [], n = 0
        for book in bible.books { s.append(n); n += book.chapters.count }
        starts = s
        var map: [Int: [Arc]] = [:]
        for arc in arcs { map[arc.a, default: []].append(arc); map[arc.b, default: []].append(arc) }
        byChapter = map.mapValues { $0.sorted { $0.weight > $1.weight } }
    }

    var count: Int { verses.count }
    var maxWeight: Int { arcs.map(\.weight).max() ?? 1 }

    func index(_ p: Place) -> Int { starts.indices.contains(p.book) ? starts[p.book] + p.chapter - 1 : 0 }

    func place(_ i: Int) -> Place {
        let book = max(0, (starts.lastIndex { $0 <= i }) ?? 0)
        return Place(book: book, chapter: i - starts[book] + 1)
    }

    /// The chapters this one reaches, strongest first.
    func links(_ i: Int) -> [(chapter: Int, weight: Int)] {
        (byChapter[i] ?? []).map { ($0.a == i ? $0.b : $0.a, $0.weight) }
    }

    func arcs(touching i: Int) -> [Arc] { byChapter[i] ?? [] }
}

extension Theme {
    /// The arc palette, mirrors --arc-1 to --arc-5 in brand/tokens.css: ochre for neighbours to Elah blue across the Bible.
    static let arcLight: [UInt32] = [0xd99a22, 0xd0612f, 0xb8324f, 0x6a3fa8, 0x1745a8]
    static let arcDark: [UInt32] = [0xf2c14e, 0xf28a52, 0xef6b86, 0xa98af2, 0x6ea8ff]

    /// A colour along the palette, t from 0 (ochre) to 1 (blue).
    static func arc(_ t: Double, dark: Bool) -> Color {
        let stops = dark ? arcDark : arcLight
        let f = min(Double(stops.count - 1) - 0.0001, max(0, t) * Double(stops.count - 1))
        let i = Int(f), u = f - Double(i)
        func c(_ hex: UInt32, _ shift: UInt32) -> Double { Double(hex >> shift & 0xff) / 255 }
        let a: UInt32 = stops[i], b: UInt32 = stops[i + 1]
        func mix(_ shift: UInt32) -> Double { let x: Double = c(a, shift), y: Double = c(b, shift); return x + (y - x) * u }
        return Color(red: mix(16), green: mix(8), blue: mix(0))
    }
}

/// Where an arc sits on the palette: how far it reaches, eased so the many short links still read warm.
private func reach(_ span: Int, of count: Int) -> Double { pow(Double(span) / Double(max(1, count - 1)), 0.45) }

/// One upper half ellipse from x0 to x1 on the baseline.
private func arcPath(_ x0: CGFloat, _ x1: CGFloat, base: CGFloat, ratio: CGFloat) -> Path {
    let rx = (x1 - x0) / 2, ry = rx * ratio, cx = x0 + rx, k: CGFloat = 0.5523
    var p = Path()
    p.move(to: CGPoint(x: x0, y: base))
    p.addCurve(to: CGPoint(x: cx, y: base - ry), control1: CGPoint(x: x0, y: base - k * ry), control2: CGPoint(x: cx - k * rx, y: base - ry))
    p.addCurve(to: CGPoint(x: x1, y: base), control1: CGPoint(x: cx + k * rx, y: base - ry), control2: CGPoint(x: x1, y: base - k * ry))
    return p
}

/// The geometry both layers share, so the bright arcs sit exactly on the faint ones.
private struct Layout {
    let size: CGSize, count: Int
    var pad: CGFloat { 8 }
    var step: CGFloat { (size.width - 2 * pad) / CGFloat(max(1, count)) }
    var base: CGFloat { size.height * 0.80 }
    var barMax: CGFloat { size.height * 0.16 }
    var ratio: CGFloat { base * 0.96 / max(1, (size.width - 2 * pad) / 2) }   // the widest arc just fits
    func x(_ i: Int) -> CGFloat { pad + (CGFloat(i) + 0.5) * step }
    func chapter(at x: CGFloat) -> Int { min(count - 1, max(0, Int((x - pad) / step))) }
}

/// Every arc, drawn once, bucketed by colour and weight so it is a few dozen strokes rather than seven thousand.
private struct ArcField: View, Equatable {
    let dark: Bool, dimmed: Bool
    static func == (l: Self, r: Self) -> Bool { l.dark == r.dark && l.dimmed == r.dimmed }
    var body: some View {
        Canvas { ctx, size in
            let map = ArcMap.shared, L = Layout(size: size, count: map.count), buckets = 24, maxW = Double(map.maxWeight)
            guard map.count > 0 else { return }
            var paths = [[Path]](repeating: [Path](repeating: Path(), count: 3), count: buckets)
            for arc in map.arcs {
                let t: Double = reach(arc.span, of: map.count) * Double(buckets)
                let c: Int = min(buckets - 1, Int(t))
                let strength: Double = (Double(arc.weight) / maxW).squareRoot() * 3
                let w: Int = min(2, Int(strength))
                paths[c][w].addPath(arcPath(L.x(arc.a), L.x(arc.b), base: L.base, ratio: L.ratio))
            }
            for c in 0..<buckets {
                let colour: Color = Theme.arc((Double(c) + 0.5) / Double(buckets), dark: dark)
                let dim: Double = dimmed ? 0.35 : 1
                for w in 0..<3 {
                    let alpha: Double = (0.28 + 0.24 * Double(w)) * dim
                    ctx.stroke(paths[c][w], with: GraphicsContext.Shading.color(colour.opacity(alpha)), lineWidth: 0.6)
                }
            }
            // the chapters: one bar each, hanging below the baseline by verse count, coloured by place in the canon
            let maxV: CGFloat = CGFloat(map.verses.max() ?? 1)
            let barAlpha: Double = dimmed ? 0.45 : 0.85
            let barWidth: CGFloat = max(0.6, L.step * 0.8)
            for (i, v) in map.verses.enumerated() {
                let x: CGFloat = L.pad + CGFloat(i) * L.step
                let h: CGFloat = L.barMax * CGFloat(v) / maxV
                let colour: Color = Theme.arc(Double(i) / Double(map.count - 1), dark: dark)
                ctx.fill(Path(CGRect(x: x, y: L.base + 2, width: barWidth, height: h)), with: GraphicsContext.Shading.color(colour.opacity(barAlpha)))
            }
        }
        .drawingGroup()
    }
}

struct ArcMapView: View {
    let open: (Place) -> Void
    @AppStorage("mapChapter") private var selected = -1   // -1 until chosen: start on David and Goliath
    @Environment(\.colorScheme) private var scheme
    private let map = ArcMap.shared
    private let bible = Bible.shared

    private var chapter: Int { selected < 0 ? map.index(.home) : min(selected, map.count - 1) }
    private var dark: Bool { scheme == .dark }

    var body: some View {
        NavigationStack {
            ScrollView { content }
            .navigationTitle("Map")
        }
    }

    /// The page itself, outside the navigation stack so it can be rendered on its own for screenshots and QA.
    var content: some View {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Every arc joins two chapters that quote or echo each other. Drag along the bottom to light one up.")
                        .font(Theme.sans(15)).foregroundStyle(Theme.secondary)
                        .padding(.horizontal, Theme.page).padding(.top, 8)
                    chart.frame(height: 280).padding(.top, 16)
                    guide.padding(.horizontal, 8)
                    detail.padding(.horizontal, Theme.page).padding(.top, 24)
                }
                .frame(maxWidth: 1100)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 32)
    }

    private var chart: some View {
        GeometryReader { geo in
            let L = Layout(size: geo.size, count: map.count)
            ZStack {
                ArcField(dark: dark, dimmed: true).equatable()
                Canvas { ctx, size in
                    let L = Layout(size: size, count: map.count)
                    for arc in map.arcs(touching: chapter).reversed() {
                        let colour: Color = Theme.arc(reach(arc.span, of: map.count), dark: dark)
                        let path: Path = arcPath(L.x(arc.a), L.x(arc.b), base: L.base, ratio: L.ratio)
                        ctx.stroke(path, with: GraphicsContext.Shading.color(colour), lineWidth: 1.6)
                    }
                    let x: CGFloat = L.x(chapter)
                    var mark = Path()
                    mark.move(to: CGPoint(x: x, y: L.base - 6))
                    mark.addLine(to: CGPoint(x: x, y: size.height))
                    ctx.stroke(mark, with: GraphicsContext.Shading.color(Color.primary), lineWidth: 1.5)
                }
            }
            .contentShape(Rectangle())
            .gesture(DragGesture(minimumDistance: 0).onChanged { selected = L.chapter(at: $0.location.x) })
            .accessibilityElement()
            .accessibilityLabel("Cross reference map")
            .accessibilityValue("\(bible.title(map.place(chapter))), linked to \(map.links(chapter).count) chapters")
            .accessibilityAdjustableAction { d in
                selected = min(map.count - 1, max(0, chapter + (d == .increment ? 1 : -1)))
            }
        }
    }

    private struct Landmark { let book: Int; let name: String }
    private static let landmarks: [Landmark] = [Landmark(book: 0, name: "Genesis"), Landmark(book: 18, name: "Psalms"), Landmark(book: 22, name: "Isaiah"),
                                                Landmark(book: 39, name: "Matthew"), Landmark(book: 44, name: "Romans"), Landmark(book: 65, name: "Rev.")]

    /// Where the books fall along the bottom.
    private var guide: some View {
        GeometryReader { geo in
            let L = Layout(size: CGSize(width: geo.size.width, height: 1), count: map.count)
            ForEach(Self.landmarks, id: \.book) { mark in
                Text(mark.name).font(Theme.sans(11, .semibold, relativeTo: .caption2)).foregroundStyle(Theme.secondary)
                    .fixedSize().position(x: L.x(map.index(Place(book: mark.book, chapter: 1))) + 16, y: 8)
            }
        }
        .frame(height: 16)
        .accessibilityHidden(true)
    }

    private var detail: some View {
        let here = map.place(chapter), links = map.links(chapter)
        return VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(bible.title(here)).font(Theme.sans(28, .bold, relativeTo: .title))
                    Text(links.isEmpty ? "No strong links" : "Linked to \(links.count) chapters").font(Theme.sans(15)).foregroundStyle(Theme.secondary)
                }
                Spacer()
                Button { open(here) } label: { Text("Read").font(Theme.sans(15, .semibold)).padding(.horizontal, 20).frame(height: 40) }
                    .buttonStyle(.plain).foregroundStyle(.white).background(Theme.button, in: Capsule())
            }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 8)], spacing: 8) {
                ForEach(Array(links.prefix(24)), id: \.chapter) { link in
                    let span: Int = abs(link.chapter - chapter)
                    Button { open(map.place(link.chapter)) } label: {
                        HStack(spacing: 8) {
                            Circle().fill(Theme.arc(reach(span, of: map.count), dark: dark)).frame(width: 10, height: 10)
                            Text(bible.title(map.place(link.chapter))).font(Theme.sans(15, .medium)).lineLimit(1)
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal, 14).frame(height: 44).background(Theme.surface, in: Capsule())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Open \(bible.title(map.place(link.chapter)))")
                }
            }
        }
    }
}
