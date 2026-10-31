import SwiftUI

/// Search every KJV verse on the device. Results group by book; tap one to open its chapter.
struct SearchView: View {
    var inTab = false
    let open: (Place) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var query = UserDefaults.standard.string(forKey: "searchQuery") ?? ""
    @State private var hits: [(ref: VerseRef, text: String)] = []
    @AppStorage("searchScope") private var scope = Bible.Scope.all
    private let bible = Bible.shared

    private var groups: [(book: Int, hits: [(ref: VerseRef, text: String)])] {
        Dictionary(grouping: hits, by: { $0.ref.place.book }).sorted { $0.key < $1.key }.map { ($0.key, $0.value) }
    }

    var body: some View {
        NavigationStack {
            List {
                Picker("Scope", selection: $scope) { ForEach(Bible.Scope.allCases, id: \.self) { Text($0.rawValue).tag($0) } }
                    .pickerStyle(.segmented).listRowBackground(Color.clear).listRowInsets(EdgeInsets())
                if query.isEmpty {
                    Text("Put words in quotes to find an exact phrase, like \u{201C}smooth stones\u{201D}.").font(.callout).foregroundStyle(.secondary).listRowBackground(Color.clear)
                }
                if !query.isEmpty && hits.isEmpty {
                    Text("No verses with \u{201C}\(query)\u{201D}").foregroundStyle(.secondary)
                } else if !hits.isEmpty {
                    Text(hits.count == 500 ? "First 500 verses" : hits.count == 1 ? "1 verse" : "\(hits.count) verses").font(.footnote).foregroundStyle(.secondary)
                }
                ForEach(groups, id: \.book) { g in
                    Section(bible.books[g.book].name) {
                        ForEach(g.hits, id: \.ref.key) { h in
                            Button { open(h.ref.place); dismiss() } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(bible.title(h.ref.place)):\(h.ref.verse)").font(.subheadline.weight(.semibold)).foregroundStyle(Theme.accent)
                                    Text(h.text).foregroundStyle(.primary).lineLimit(3)
                                }
                                .padding(.vertical, 4)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            #if os(iOS)
            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Words in any verse")
            #else
            .searchable(text: $query, prompt: "Words in any verse")
            #endif
            .task(id: "\(query)|\(scope.rawValue)") {
                try? await Task.sleep(for: .milliseconds(200))
                let q = query, sc = scope
                hits = await Task.detached { Bible.shared.search(q, scope: sc) }.value
            }
            .frame(maxWidth: 760)
            .frame(maxWidth: .infinity)
            .navigationTitle("Search")
            .toolbar { if !inTab { ToolbarItem(placement: .cancellationAction) { Button("Done") { dismiss() } } } }
        }
        #if os(macOS)
        .frame(minWidth: 460, minHeight: 560)
        #endif
    }
}
