import SwiftUI

/// One verse, as "book.chapter.verse" for storage.
struct VerseRef: Hashable {
    let place: Place
    let verse: Int
    var key: String { "\(place.book).\(place.chapter).\(verse)" }
}

/// Highlights and bookmarks, kept on the device in UserDefaults. No account, no sync yet.
final class Marks: ObservableObject {
    static let colors: [(name: String, color: Color)] = [
        ("Yellow", Color(hex: 0xffd84d)), ("Green", Color(hex: 0x7ed98a)),
        ("Blue", Color(hex: 0x7fb2ff)), ("Pink", Color(hex: 0xff9fc4)),
    ]
    private let defaults: UserDefaults
    @Published private(set) var highlights: [String: Int]
    @Published private(set) var bookmarks: Set<String>

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        highlights = defaults.dictionary(forKey: "highlights") as? [String: Int] ?? [:]
        bookmarks = Set(defaults.stringArray(forKey: "bookmarks") ?? [])
    }

    func highlight(_ r: VerseRef) -> Int? { highlights[r.key] }

    func setHighlight(_ r: VerseRef, _ color: Int?) {
        highlights[r.key] = color
        defaults.set(highlights, forKey: "highlights")
    }

    func isBookmarked(_ r: VerseRef) -> Bool { bookmarks.contains(r.key) }

    func toggleBookmark(_ r: VerseRef) {
        if bookmarks.remove(r.key) == nil { bookmarks.insert(r.key) }
        defaults.set(bookmarks.sorted(), forKey: "bookmarks")
    }
}

/// A verse with its number. Press and hold for highlight, copy, share and bookmark.
struct VerseRow: View {
    let number: Int
    let text: String
    let size: Double
    var serif = false
    var spacing = 0.35
    var speaking = false
    @ObservedObject var marks: Marks
    let ref: VerseRef
    let cite: String

    var body: some View {
        let mark = marks.highlight(ref)
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            (Text("\(number) ").font(.system(size: size * 0.6, weight: .semibold)).foregroundColor(Theme.secondary)
             + Text(text).font(.system(size: size, design: serif ? .serif : .default)))
                .lineSpacing(size * spacing)
            if marks.isBookmarked(ref) {
                Image(systemName: "bookmark.fill").font(.caption).foregroundStyle(Theme.accent).padding(.leading, 6)
                    .accessibilityLabel("Bookmarked")
            }
        }
        .padding(.horizontal, 4).padding(.vertical, 2)
        .background(mark.map { Marks.colors[$0].color.opacity(0.35) } ?? .clear, in: RoundedRectangle(cornerRadius: 6))
        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Theme.accent, lineWidth: speaking ? 2 : 0))
        .animation(.easeInOut(duration: 0.2), value: speaking)
        .contentShape(Rectangle())
        .contextMenu {
            Menu("Highlight") {
                ForEach(Marks.colors.indices, id: \.self) { i in
                    Button(Marks.colors[i].name) { marks.setHighlight(ref, i) }
                }
                if mark != nil { Button("Remove Highlight", role: .destructive) { marks.setHighlight(ref, nil) } }
            }
            Button(marks.isBookmarked(ref) ? "Remove Bookmark" : "Bookmark") { marks.toggleBookmark(ref) }
            Button("Copy") { copy("\(text)\n\(cite)") }
            ShareLink(item: "\(text)\n\(cite)")
        }
    }

    private func copy(_ s: String) {
        #if os(iOS)
        UIPasteboard.general.string = s
        #else
        NSPasteboard.general.clearContents(); NSPasteboard.general.setString(s, forType: .string)
        #endif
    }
}
