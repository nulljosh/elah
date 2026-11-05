import SwiftUI

/// The square card a verse is shared as: white serif on the icon's navy under its arcs, the reference under it.
struct VerseCard: View {
    let text: String
    let cite: String

    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            ArcMark().frame(width: 120, height: 120)
            Text(text)
                .font(.system(size: 64, weight: .regular, design: .serif))
                .lineSpacing(14)
                .minimumScaleFactor(0.35)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            Text(cite).font(.system(size: 40, weight: .semibold)).opacity(0.85)
        }
        .foregroundStyle(.white)
        .padding(96)
        .frame(width: 1080, height: 1080)
        .background(Theme.iconTile)
    }

    @MainActor func image() -> Image? {
        let r = ImageRenderer(content: self)
        r.scale = 1
        return r.cgImage.map { Image(decorative: $0, scale: 1) }
    }
}

/// Preview of the card with a share button.
struct ShareImageSheet: View {
    let text: String
    let cite: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                if let img = VerseCard(text: text, cite: cite).image() {
                    img.resizable().scaledToFit().clipShape(RoundedRectangle(cornerRadius: 20))
                        .accessibilityLabel("\(text) \(cite)")
                    ShareLink(item: img, preview: SharePreview(cite, image: img)) {
                        Label("Share Image", systemImage: "square.and.arrow.up").frame(maxWidth: .infinity, minHeight: Theme.control)
                    }
                    .buttonStyle(.borderedProminent).tint(Theme.button).buttonBorderShape(.capsule)
                }
            }
            .padding(Theme.page)
            .frame(maxWidth: 520)
            .navigationTitle(cite)
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Done") { dismiss() } } }
        }
        #if os(macOS)
        .frame(minWidth: 460, minHeight: 600)
        #endif
    }
}

/// The app icon's mark: five cross references on one line, coloured by reach, from brand/mark.svg on its 1024 grid.
struct ArcMark: View {
    /// Each arc is a span between two places on the line, longest first. Keep in step with brand/mark.svg.
    static let spans: [(CGFloat, CGFloat)] = [(144, 880), (144, 624), (400, 880), (272, 528), (656, 816)]
    static let base: CGFloat = 696, weight: CGFloat = 58
    var drawn: CGFloat = 1
    var color: Color? = nil

    var body: some View {
        GeometryReader { geo in
            let k: CGFloat = min(geo.size.width, geo.size.height) / 824
            ZStack {
                ForEach(0..<Self.spans.count, id: \.self) { i in
                    let tint: Color = color ?? Theme.arc(1 - Double(i) / 4, dark: true)
                    MarkArc(a: Self.spans[i].0, b: Self.spans[i].1).trim(from: 0, to: drawn)
                        .stroke(tint, style: StrokeStyle(lineWidth: Self.weight * k, lineCap: .round))
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

/// One half circle of the mark, on the 1024 grid cropped to the square around the mark.
private struct MarkArc: Shape {
    let a: CGFloat, b: CGFloat
    func path(in rect: CGRect) -> Path {
        let k: CGFloat = min(rect.width, rect.height) / 824
        let r: CGFloat = (b - a) / 2, cx: CGFloat = (a + b) / 2
        var path = Path()
        for n in 0...48 {
            let t: CGFloat = .pi + CGFloat(n) / 48 * .pi
            let p = CGPoint(x: rect.midX + (cx + r * cos(t) - 512) * k, y: rect.midY + (ArcMark.base + r * sin(t) - 512) * k)
            if n == 0 { path.move(to: p) } else { path.addLine(to: p) }
        }
        return path
    }
}
