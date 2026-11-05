import SwiftUI
#if os(iOS)
import UIKit
#else
import AppKit
#endif

/// Gustave Doré's Bible engravings (1866, public domain), each set as a halftone plate at the chapter it illustrates.
/// The files in Plates/ are dot masks, dithered by hand from the Wikimedia Commons scans, tinted with the band colours.
struct Plate: Identifiable, Hashable {
    let id: String          // file name, plate-<id>.png
    let subject: String
    let place: Place

    static let all: [Plate] = [
        Plate(id: "goliath", subject: "David and Goliath", place: Place(book: 8, chapter: 17)),
        Plate(id: "saul", subject: "Saul and David", place: Place(book: 8, chapter: 18)),
        Plate(id: "spared", subject: "David spares Saul", place: Place(book: 8, chapter: 24)),
        Plate(id: "mourns", subject: "David mourns Absalom", place: Place(book: 9, chapter: 18)),
        Plate(id: "noah", subject: "Noah", place: Place(book: 0, chapter: 8)),
        Plate(id: "abraham", subject: "Abraham", place: Place(book: 0, chapter: 12)),
        Plate(id: "moses", subject: "Moses", place: Place(book: 1, chapter: 32)),
        Plate(id: "samson", subject: "Samson", place: Place(book: 6, chapter: 16)),
        Plate(id: "daniel", subject: "Daniel", place: Place(book: 26, chapter: 6)),
    ]

    static func at(_ p: Place) -> Plate? { all.first { $0.place == p } }

    var image: Image? {
        guard let url = Bundle.main.url(forResource: "plate-\(id)", withExtension: "png") else { return nil }
        #if os(iOS)
        return UIImage(contentsOfFile: url.path).map { Image(uiImage: $0) }
        #else
        return NSImage(contentsOf: url).map { Image(nsImage: $0) }
        #endif
    }
}

extension Theme {
    /// The blue band and the engraving tint on it, mirrors --band and --band-art in brand/tokens.css.
    static let band = Color(light: 0x1745a8, dark: 0x12347f)
    static let bandArt = Color(light: 0x9fbaf5, dark: 0x7d9df0)
}

/// One engraving: the dot mask filled with the light band tint on the deep band blue.
struct PlateView: View {
    let plate: Plate
    var body: some View {
        Rectangle().fill(Theme.band)
            .overlay {
                if let image = plate.image {
                    Rectangle().fill(Theme.bandArt).mask { image.resizable().scaledToFill() }
                }
            }
            .clipped()
            .accessibilityElement()
            .accessibilityLabel("Engraving by Gustave Doré: \(plate.subject)")
    }
}

/// The plate at the head of a chapter, with its credit.
struct ChapterPlate: View {
    let plate: Plate
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            PlateView(plate: plate).aspectRatio(3 / 2, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            Text("\(plate.subject). Gustave Doré, 1866.").font(Theme.sans(13, relativeTo: .footnote)).foregroundStyle(Theme.secondary)
        }
    }
}

/// Every plate in canon order, each opening its chapter.
struct PlateStrip: View {
    let open: (Place) -> Void
    private let bible = Bible.shared
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Plate.all.sorted { ($0.place.book, $0.place.chapter) < ($1.place.book, $1.place.chapter) }) { plate in
                    Button { open(plate.place) } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            PlateView(plate: plate).frame(width: 168, height: 112).clipShape(RoundedRectangle(cornerRadius: 12))
                            Text(plate.subject).font(Theme.sans(15, .semibold)).lineLimit(1)
                            Text(bible.title(plate.place)).font(Theme.sans(13)).foregroundStyle(Theme.secondary)
                        }
                        .frame(width: 168, alignment: .leading)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("\(plate.subject), open \(bible.title(plate.place))")
                }
            }
        }
    }
}
