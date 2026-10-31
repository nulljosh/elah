import SwiftUI

/// Where you left off, and one verse a day. The verse is the same for everyone on a given day.
struct TodayView: View {
    let read: () -> Void
    @AppStorage("book") private var book = Place.home.book
    @AppStorage("chapter") private var chapter = Place.home.chapter
    @State private var shareCard: (text: String, cite: String)?
    private let bible = Bible.shared

    static let verses = [
        "1 Samuel 17:45", "1 Samuel 17:47", "1 Samuel 16:7", "Psalms 23:1", "Psalms 46:1", "Psalms 46:10", "Psalms 27:1",
        "Psalms 119:105", "Psalms 121:1", "Psalms 91:1", "Psalms 34:8", "Psalms 37:4", "Psalms 139:14", "Psalms 118:24",
        "Proverbs 3:5", "Proverbs 3:6", "Proverbs 16:3", "Proverbs 18:10", "Isaiah 40:31", "Isaiah 41:10", "Isaiah 26:3",
        "Isaiah 43:2", "Jeremiah 29:11", "Lamentations 3:22", "Lamentations 3:23", "Joshua 1:9", "Deuteronomy 31:6",
        "Micah 6:8", "Zephaniah 3:17", "Nahum 1:7", "Matthew 5:9", "Matthew 6:33", "Matthew 6:34", "Matthew 11:28",
        "Matthew 19:26", "Mark 10:27", "Luke 1:37", "John 1:5", "John 3:16", "John 8:12", "John 14:6", "John 14:27",
        "John 15:13", "John 16:33", "Romans 5:8", "Romans 8:28", "Romans 8:38", "Romans 12:2", "Romans 12:12",
        "Romans 15:13", "1 Corinthians 13:4", "1 Corinthians 16:14", "2 Corinthians 5:7", "2 Corinthians 12:9",
        "Galatians 6:9", "Ephesians 2:8", "Philippians 4:6", "Philippians 4:7", "Philippians 4:13", "Colossians 3:23",
        "2 Timothy 1:7", "Hebrews 11:1", "Hebrews 13:8", "James 1:5", "1 Peter 5:7", "1 John 4:18", "1 John 4:19",
    ]

    static func ofTheDay(_ date: Date = .now) -> String {
        verses[(Calendar.current.ordinality(of: .day, in: .era, for: date) ?? 0) % verses.count]
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Today").font(Theme.sans(34, .bold, relativeTo: .largeTitle))
                    card("Continue reading") {
                        Button { read() } label: {
                            HStack {
                                Image(systemName: "book").foregroundStyle(Theme.accent)
                                Text(bible.title(Place(book: book, chapter: chapter))).font(.headline)
                                Spacer()
                                Image(systemName: "chevron.right").foregroundStyle(.secondary)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                    if let r = bible.ref(Self.ofTheDay()) {
                        let text = bible.verses(r.place)[r.verse - 1]
                        let cite = "\(bible.title(r.place)):\(r.verse) KJV"
                        card("Verse of the day") {
                            VStack(alignment: .leading, spacing: 16) {
                                Text(text).font(.system(.title3, design: .serif))
                                Text(cite).font(.subheadline.weight(.semibold)).foregroundStyle(Theme.accent)
                                HStack(spacing: 12) {
                                    Button("Read \(bible.title(r.place))") { book = r.place.book; chapter = r.place.chapter; read() }
                                        .buttonStyle(.borderedProminent).tint(Theme.button)
                                    Button { shareCard = (text, cite) } label: { Label("Share", systemImage: "square.and.arrow.up") }
                                        .buttonStyle(.bordered)
                                }
                                .controlSize(.large)
                            }
                        }
                    }
                }
                .frame(maxWidth: Theme.measure, alignment: .leading)
                .sheet(isPresented: Binding(get: { shareCard != nil }, set: { if !$0 { shareCard = nil } })) {
                    if let c = shareCard { ShareImageSheet(text: c.text, cite: c.cite) }
                }
                .padding(.horizontal, Theme.page).padding(.vertical, 24)
                .frame(maxWidth: .infinity)
            }
        }
    }

    private func card<C: View>(_ title: String, @ViewBuilder _ content: () -> C) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title.uppercased()).font(.footnote.weight(.semibold)).foregroundStyle(Theme.secondary)
            content()
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 28))
    }
}
