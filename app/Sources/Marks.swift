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
    @Published private(set) var notes: [String: String]

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        highlights = defaults.dictionary(forKey: "highlights") as? [String: Int] ?? [:]
        bookmarks = Set(defaults.stringArray(forKey: "bookmarks") ?? [])
        notes = defaults.dictionary(forKey: "notes") as? [String: String] ?? [:]
    }

    func note(_ r: VerseRef) -> String? { notes[r.key] }

    func setNote(_ r: VerseRef, _ text: String) {
        let t = text.trimmingCharacters(in: .whitespacesAndNewlines)
        notes[r.key] = t.isEmpty ? nil : t
        defaults.set(notes, forKey: "notes")
    }

    /// "b.c.v" back to a verse, sorted in canon order by the callers.
    static func ref(_ key: String) -> VerseRef? {
        let n = key.split(separator: ".").compactMap { Int($0) }
        return n.count == 3 ? VerseRef(place: Place(book: n[0], chapter: n[1]), verse: n[2]) : nil
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
    @State private var editing = false
    @State private var sharingImage = false
    @State private var draft = ""

    var body: some View {
        let mark = marks.highlight(ref)
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            (Text("\(number) ").font(.system(size: size * 0.6, weight: .semibold)).foregroundColor(Theme.secondary)
             + Text(text).font(serif ? .system(size: size, design: .serif) : Theme.sans(size)))
                .lineSpacing(size * spacing)
            if marks.note(ref) != nil {
                Image(systemName: "note.text").font(.caption).foregroundStyle(Theme.accent).padding(.leading, 6)
                    .accessibilityLabel("Has a note")
            }
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
            Button(marks.note(ref) == nil ? "Add Note" : "Edit Note") { draft = marks.note(ref) ?? ""; editing = true }
            Button("Copy") { copy("\(text)\n\(cite)") }
            ShareLink(item: "\(text)\n\(cite)")
            Button("Share as Image", systemImage: "photo") { sharingImage = true }
        }
        .sheet(isPresented: $sharingImage) { ShareImageSheet(text: text, cite: cite) }
        .sheet(isPresented: $editing) {
            NavigationStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text(text).font(.callout).foregroundStyle(.secondary).lineLimit(4)
                    TextEditor(text: $draft).font(.body).scrollContentBackground(.hidden)
                        .padding(8).background(Theme.surface, in: RoundedRectangle(cornerRadius: 20))
                }
                .padding(20)
                .navigationTitle(cite)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) { Button("Cancel") { editing = false } }
                    ToolbarItem(placement: .confirmationAction) { Button("Save") { marks.setNote(ref, draft); editing = false } }
                }
            }
            #if os(macOS)
            .frame(minWidth: 420, minHeight: 320)
            #endif
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
