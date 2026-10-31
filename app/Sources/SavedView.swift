import SwiftUI

/// Everything you marked, in canon order: bookmarks, highlights and notes.
struct SavedView: View {
    let open: (Place) -> Void
    @EnvironmentObject private var marks: Marks
    @AppStorage("savedKind") private var kind = "bookmarks"
    private let bible = Bible.shared

    private var keys: [String] {
        switch kind {
        case "highlights": Array(marks.highlights.keys)
        case "notes": Array(marks.notes.keys)
        default: Array(marks.bookmarks)
        }
    }

    private var refs: [VerseRef] {
        keys.compactMap(Marks.ref).sorted { ($0.place.book, $0.place.chapter, $0.verse) < ($1.place.book, $1.place.chapter, $1.verse) }
    }

    var body: some View {
        NavigationStack {
            List {
                Picker("Kind", selection: $kind) {
                    Text("Bookmarks").tag("bookmarks")
                    Text("Highlights").tag("highlights")
                    Text("Notes").tag("notes")
                }
                .pickerStyle(.segmented)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                if refs.isEmpty {
                    Text("Press and hold a verse to bookmark it, highlight it or add a note.")
                        .foregroundStyle(.secondary).listRowBackground(Color.clear)
                }
                ForEach(refs, id: \.key) { r in
                    Button { open(r.place) } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 8) {
                                if let c = marks.highlight(r) { Circle().fill(Marks.colors[c].color).frame(width: 10, height: 10) }
                                Text("\(bible.title(r.place)):\(r.verse)").font(.subheadline.weight(.semibold)).foregroundStyle(Theme.accent)
                            }
                            Text(bible.verses(r.place)[r.verse - 1]).foregroundStyle(.primary).lineLimit(3)
                            if kind == "notes", let n = marks.note(r) {
                                Text(n).font(.callout).foregroundStyle(.secondary).padding(.top, 2)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle("Saved")
        }
    }
}
