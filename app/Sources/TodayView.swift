import SwiftUI
import UserNotifications

/// Where you left off, and one verse a day. The verse is the same for everyone on a given day.
struct TodayView: View {
    let read: () -> Void
    @AppStorage("book") private var book = Place.home.book
    @AppStorage("chapter") private var chapter = Place.home.chapter
    @State private var shareCard: (text: String, cite: String)?
    @AppStorage("verseReminder") private var reminder = false
    @AppStorage("verseMinute") private var minute = 8 * 60
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
                    card("Engravings") {
                        PlateStrip { p in book = p.book; chapter = p.chapter; read() }
                    }
                    card("Reading plan") {
                        PlanCard { p in book = p.book; chapter = p.chapter; read() }
                    }
                    card("Daily verse") {
                        Toggle("Send me the verse of the day", isOn: $reminder).tint(Theme.button)
                        if reminder {
                            DatePicker("At", selection: Binding(
                                get: { Calendar.current.startOfDay(for: .now).addingTimeInterval(Double(minute) * 60) },
                                set: { minute = Calendar.current.component(.hour, from: $0) * 60 + Calendar.current.component(.minute, from: $0) }
                            ), displayedComponents: .hourAndMinute)
                        }
                    }
                }
                .frame(maxWidth: Theme.measure, alignment: .leading)
                .task(id: "\(reminder)\(minute)") { await DailyVerse.schedule(on: reminder, minute: minute) { reminder = $0 } }
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

/// The verse of the day as a local notification. Thirty days are queued ahead, refreshed every time Today appears.
enum DailyVerse {
    static let days = 30

    /// Title and body for each of the next `days` days starting at `from`, at `minute` past midnight.
    static func plan(from: Date = .now, minute: Int, bible: Bible = .shared) -> [(date: Date, cite: String, text: String)] {
        let cal = Calendar.current, start = cal.startOfDay(for: from)
        return (0..<days).compactMap { d in
            guard let day = cal.date(byAdding: .day, value: d, to: start),
                  let fire = cal.date(byAdding: .minute, value: minute, to: day), fire > from,
                  let r = bible.ref(TodayView.ofTheDay(day)) else { return nil }
            return (fire, "\(bible.title(r.place)):\(r.verse)", bible.verses(r.place)[r.verse - 1])
        }
    }

    static func schedule(on: Bool, minute: Int, denied: (Bool) -> Void) async {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: (0...days).map { "verse-\($0)" })
        guard on else { return }
        guard (try? await center.requestAuthorization(options: [.alert, .sound])) == true else { return denied(false) }
        for (i, p) in plan(minute: minute).enumerated() {
            let content = UNMutableNotificationContent()
            content.title = p.cite
            content.body = p.text
            let when = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: p.date)
            try? await center.add(UNNotificationRequest(identifier: "verse-\(i)", content: content, trigger: UNCalendarNotificationTrigger(dateMatching: when, repeats: false)))
        }
    }
}
