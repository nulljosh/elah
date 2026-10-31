import SwiftUI
#if os(iOS)
import SafariServices
#endif

@main
struct BibleApp: App {
    var body: some Scene {
        WindowGroup { ReaderView() }
        #if os(macOS)
        .defaultSize(width: 760, height: 900)
        #endif
    }
}

struct ReaderView: View {
    @AppStorage("book") private var book = Place.home.book
    @AppStorage("chapter") private var chapter = Place.home.chapter
    @AppStorage("textSize") private var textSize = 19.0
    @State private var showNIV = false
    @Environment(\.openURL) private var openURL
    @State private var picking = false
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
            .onAppear { picking = UserDefaults.standard.bool(forKey: "showBooks") }
        }
        .tint(Theme.accent)
    }

    private var kjv: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(bible.title(place)).font(.largeTitle.bold()).padding(.bottom, 8)
                ForEach(Array(bible.verses(place).enumerated()), id: \.offset) { i, v in
                    (Text("\(i + 1) ").font(.system(size: textSize * 0.6, weight: .semibold)).foregroundColor(Theme.secondary)
                     + Text(v).font(.system(size: textSize)))
                        .lineSpacing(textSize * 0.35)
                        .textSelection(.enabled)
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
    }

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
            Menu {
                Button("Larger Text") { textSize = min(textSize + 2, 34) }
                Button("Smaller Text") { textSize = max(textSize - 2, 13) }
            } label: { Label("Text Size", systemImage: "textformat.size") }
        }
    }

    private func go(_ p: Place) { book = p.book; chapter = p.chapter }

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
