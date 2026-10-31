import SwiftUI

/// The square card a verse is shared as: white serif on the icon's blue, the reference under it.
struct VerseCard: View {
    let text: String
    let cite: String

    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            BookMark().fill(.white.opacity(0.9)).frame(width: 72, height: 72)
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
        .background(LinearGradient(colors: [Color(hex: 0x4f8df0), Color(hex: 0x1745a8)], startPoint: .top, endPoint: .bottom))
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

/// The app icon's glyph, an open book with a ribbon, from brand/mark.svg on its 1024 grid.
struct BookMark: Shape {
    func path(in rect: CGRect) -> Path {
        let k = min(rect.width, rect.height) / 640, ox = rect.minX - 192 * k, oy = rect.minY - 220 * k
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: ox + x * k, y: oy + y * k) }
        var path = Path()
        path.move(to: p(500, 316)); path.addCurve(to: p(232, 282), control1: p(430, 262), control2: p(330, 252))
        path.addLine(to: p(232, 692)); path.addCurve(to: p(500, 726), control1: p(330, 664), control2: p(430, 674)); path.closeSubpath()
        path.move(to: p(524, 316)); path.addCurve(to: p(792, 282), control1: p(594, 262), control2: p(694, 252))
        path.addLine(to: p(792, 692)); path.addCurve(to: p(524, 726), control1: p(694, 664), control2: p(594, 674)); path.closeSubpath()
        path.move(to: p(486, 742)); path.addLine(to: p(538, 742)); path.addLine(to: p(538, 826))
        path.addLine(to: p(512, 800)); path.addLine(to: p(486, 826)); path.closeSubpath()
        return path
    }
}
