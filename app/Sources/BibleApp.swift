import SwiftUI
#if os(iOS)
import SafariServices
#endif

@main
struct BibleApp: App {
    var body: some Scene {
        WindowGroup { RootView() }
        #if os(macOS)
        .defaultSize(width: 760, height: 900)
        #endif
    }
}

struct RootView: View {
    @AppStorage("tab") private var tab = "bible"
    @StateObject private var marks = Marks()
    var body: some View {
        TabView(selection: $tab) {
            TodayView { tab = "bible" }
                .tabItem { Label("Today", systemImage: "sun.max") }.tag("today")
            ReaderView()
                .tabItem { Label("Bible", systemImage: "book") }.tag("bible")
            SearchView(inTab: true) { p in
                UserDefaults.standard.set(p.book, forKey: "book"); UserDefaults.standard.set(p.chapter, forKey: "chapter"); tab = "bible"
            }
                .tabItem { Label("Search", systemImage: "magnifyingglass") }.tag("search")
            SavedView { p in
                UserDefaults.standard.set(p.book, forKey: "book"); UserDefaults.standard.set(p.chapter, forKey: "chapter"); tab = "bible"
            }
                .tabItem { Label("Saved", systemImage: "bookmark") }.tag("saved")
        }
        .environmentObject(marks)
        .tint(Theme.accent)
    }
}

struct ReaderView: View {
    @AppStorage("book") private var book = Place.home.book
    @AppStorage("chapter") private var chapter = Place.home.chapter
    @AppStorage("textSize") private var textSize = 19.0
    @State private var showNIV = false
    @Environment(\.openURL) private var openURL
    @State private var picking = false
    @State private var reading = false
    @AppStorage("serif") private var serif = false
    @AppStorage("spacing") private var spacing = 0.35
    @EnvironmentObject private var marks: Marks
    @StateObject private var speaker = Speaker()
    private let bible = Bible.shared

    private var place: Place { Place(book: book, chapter: chapter) }

    var body: some View {
        NavigationStack {
            kjv
            .toolbar { toolbar }
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showNIV) { SafariView(url: bible.gatewayURL(place, .niv)).ignoresSafeArea() }
            #endif
            .sheet(isPresented: $picking) { BookPicker(place: place) { go($0) } }
            .onAppear { picking = UserDefaults.standard.bool(forKey: "showBooks")}
            .task { if UserDefaults.standard.bool(forKey: "showPlayer") { speaker.preview(bible.verses(place), at: 12) }
                if UserDefaults.standard.bool(forKey: "showReading") { try? await Task.sleep(for: .seconds(1)); reading = true } }
        }
        .tint(Theme.accent)
    }

    private var kjv: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(bible.title(place)).font(.system(.largeTitle, design: serif ? .serif : .default).bold()).padding(.bottom, 8)
                ForEach(Array(bible.verses(place).enumerated()), id: \.offset) { i, v in
                    let ref = VerseRef(place: place, verse: i + 1)
                    VerseRow(number: i + 1, text: v, size: textSize, serif: serif, spacing: spacing, speaking: speaker.verse == i + 1, marks: marks, ref: ref, cite: "\(bible.title(place)):\(i + 1) KJV")
                }
                HStack {
                    if let p = bible.previous(place) { chapterButton("chevron.left", bible.title(p)) { go(p) } }
                    Spacer()
                    if let n = bible.next(place) { chapterButton("chevron.right", bible.title(n)) { go(n) } }
                }
                .padding(.top, 24)
            }
            .frame(maxWidth: Theme.measure, alignment: .leading)
            .padding(.horizontal, Theme.page).padding(.vertical, 24)
            .frame(maxWidth: .infinity)
        }
        .id(place)
        .safeAreaInset(edge: .bottom) { if speaker.active { listenBar } }
    }

    private var listenBar: some View {
        HStack(spacing: 4) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Listening").font(.caption).foregroundStyle(Theme.secondary)
                Text("\(bible.title(place)):\(speaker.verse ?? 1)").font(.subheadline.weight(.semibold)).monospacedDigit()
                    .lineLimit(1).minimumScaleFactor(0.7)
            }
            Spacer()
            Group {
                Button { speaker.skip(-1) } label: { Image(systemName: "backward.fill") }.accessibilityLabel("Previous verse")
                Button { speaker.toggle(bible.verses(place)) } label: { Image(systemName: speaker.playing ? "pause.fill" : "play.fill") }
                    .accessibilityLabel(speaker.playing ? "Pause" : "Play")
                Button { speaker.skip(1) } label: { Image(systemName: "forward.fill") }.accessibilityLabel("Next verse")
                Menu {
                    ForEach([0.75, 1.0, 1.25, 1.5], id: \.self) { r in
                        Button { speaker.setRate(r) } label: { if speaker.rate == r { Label(rateLabel(r), systemImage: "checkmark") } else { Text(rateLabel(r)) } }
                    }
                } label: { Text(rateLabel(speaker.rate)).font(.subheadline.weight(.semibold)).monospacedDigit() }
                    .accessibilityLabel("Speed \(rateLabel(speaker.rate))")
                Button { speaker.stop() } label: { Image(systemName: "xmark") }.accessibilityLabel("Stop listening")
            }
            .frame(width: 40, height: 44)
            .contentShape(Rectangle())
            .buttonStyle(.plain)
            .foregroundStyle(Theme.accent)
        }
        .padding(.leading, 16).padding(.trailing, 4).padding(.vertical, 6)
        .background(.regularMaterial, in: Capsule())
        .padding(.horizontal, 12).padding(.bottom, 8)
        .frame(maxWidth: Theme.measure)
    }

    private func rateLabel(_ r: Double) -> String { r == 1 ? "1x" : String(format: "%gx", r) }

    private func chapterButton(_ icon: String, _ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) { Label(title, systemImage: icon).frame(height: Theme.control).padding(.horizontal, 16) }
            .buttonStyle(.plain).background(Theme.surface, in: Capsule())
            .accessibilityLabel(title)
    }

    @ToolbarContentBuilder private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            Button { go(.home) } label: { Label("David and Goliath", systemImage: "house") }
        }
        ToolbarItem(placement: .principal) {
            Button { picking = true } label: {
                Text(bible.title(place)).font(.headline).lineLimit(1).fixedSize()
                    .padding(.horizontal, 14).padding(.vertical, 6).background(Theme.surface, in: Capsule())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Choose book and chapter, now \(bible.title(place))")
        }
        ToolbarItemGroup(placement: .primaryAction) {
            Menu {
                Button("King James Version", systemImage: "checkmark") {}
                Button("New International Version (BibleGateway)") { openNIV() }
            } label: { Text("KJV").font(.subheadline.weight(.semibold)) }
            Button { speaker.toggle(bible.verses(place)) } label: {
                Label(speaker.playing ? "Pause" : "Listen", systemImage: speaker.playing ? "pause.fill" : "headphones")
            }
            Button { reading = true } label: { Label("Reading Settings", systemImage: "textformat.size") }
                .popover(isPresented: $reading) { ReadingSettings().presentationCompactAdaptation(.sheet).presentationDetents([.height(340)]) }
        }
    }

    private func go(_ p: Place) { speaker.stop(); book = p.book; chapter = p.chapter }

    /// The NIV is licensed by Biblica, so it opens BibleGateway's own page rather than living in the app.
    private func openNIV() {
        #if os(iOS)
        showNIV = true
        #else
        openURL(bible.gatewayURL(place, .niv))
        #endif
    }
}

struct BookPicker: View {
    let place: Place
    let pick: (Place) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var open: Int?
    private let bible = Bible.shared
    private let columns = [GridItem(.adaptive(minimum: 52), spacing: 8)]

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                List {
                    section("Old Testament", 0..<39)
                    section("New Testament", 39..<bible.books.count)
                }
                .onAppear { open = place.book; proxy.scrollTo(place.book, anchor: .top) }
            }
            .navigationTitle("Books")
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Done") { dismiss() } } }
        }
        #if os(macOS)
        .frame(minWidth: 420, minHeight: 560)
        #endif
    }

    private func section(_ title: String, _ range: Range<Int>) -> some View {
        Section(title) {
            ForEach(range, id: \.self) { i in
                let b = bible.books[i]
                Button { withAnimation(.easeInOut(duration: 0.2)) { open = open == i ? nil : i } } label: {
                    HStack {
                        Text(b.name).foregroundStyle(i == place.book ? Theme.accent : .primary)
                        Spacer()
                        Image(systemName: open == i ? "chevron.up" : "chevron.down").foregroundStyle(.secondary).font(.footnote)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .id(i)
                if open == i {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(1...b.chapters.count, id: \.self) { c in
                            Button("\(c)") { pick(Place(book: i, chapter: c)); dismiss() }
                                .buttonStyle(.plain).frame(maxWidth: .infinity, minHeight: 44)
                                .background(place == Place(book: i, chapter: c) ? Theme.accent.opacity(0.2) : Theme.surface, in: RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        #if os(macOS)
        .frame(minWidth: 0)
        #endif
    }
}

#if os(iOS)
struct SafariView: UIViewControllerRepresentable {
    let url: URL
    func makeUIViewController(context: Context) -> SFSafariViewController { SFSafariViewController(url: url) }
    func updateUIViewController(_ vc: SFSafariViewController, context: Context) {}
}
#endif
