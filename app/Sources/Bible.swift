import Foundation

/// A place in the Bible: book index (0 to 65) and chapter (1 based).
struct Place: Codable, Hashable {
    var book: Int
    var chapter: Int
    /// The home passage: David and Goliath.
    static let home = Place(book: 8, chapter: 17)
}

struct Book: Decodable {
    let name: String
    let chapters: [[String]]
}

/// The King James text, bundled (public domain), loaded once.
final class Bible {
    static let shared = Bible()
    let books: [Book]

    init(data: Data? = nil) {
        let raw = data ?? Bundle.main.url(forResource: "kjv", withExtension: "json").flatMap { try? Data(contentsOf: $0) } ?? Data()
        books = (try? JSONDecoder().decode([Book].self, from: raw)) ?? []
    }

    func verses(_ p: Place) -> [String] {
        guard books.indices.contains(p.book), books[p.book].chapters.indices.contains(p.chapter - 1) else { return [] }
        return books[p.book].chapters[p.chapter - 1]
    }

    func title(_ p: Place) -> String { books.indices.contains(p.book) ? "\(books[p.book].name) \(p.chapter)" : "" }

    func next(_ p: Place) -> Place? {
        if p.chapter < books[p.book].chapters.count { return Place(book: p.book, chapter: p.chapter + 1) }
        return p.book + 1 < books.count ? Place(book: p.book + 1, chapter: 1) : nil
    }

    func previous(_ p: Place) -> Place? {
        if p.chapter > 1 { return Place(book: p.book, chapter: p.chapter - 1) }
        return p.book > 0 ? Place(book: p.book - 1, chapter: books[p.book - 1].chapters.count) : nil
    }

    /// Parses "1 Samuel 17:49" into a verse, nil if the book, chapter or verse does not exist.
    func ref(_ s: String) -> VerseRef? {
        guard let space = s.lastIndex(of: " ") else { return nil }
        let name = String(s[..<space]), cv = s[s.index(after: space)...].split(separator: ":")
        guard cv.count == 2, let c = Int(cv[0]), let v = Int(cv[1]),
              let b = books.firstIndex(where: { $0.name == name }) else { return nil }
        let p = Place(book: b, chapter: c)
        return verses(p).indices.contains(v - 1) ? VerseRef(place: p, verse: v) : nil
    }

    enum Scope: String, CaseIterable { case all = "All", old = "Old Testament", new = "New Testament" }

    /// Every verse containing all the words of the query, in canon order. A query in double quotes matches as one phrase.
    func search(_ query: String, scope: Scope = .all, limit: Int = 500) -> [(ref: VerseRef, text: String)] {
        let q = query.lowercased().trimmingCharacters(in: .whitespaces)
        let quoted = q.count > 2 && (q.hasPrefix("\"") || q.hasPrefix("\u{201C}")) && (q.hasSuffix("\"") || q.hasSuffix("\u{201D}"))
        let words = quoted ? [String(q.dropFirst().dropLast())] : q.split(separator: " ").map(String.init).filter { !$0.isEmpty }
        guard !words.isEmpty else { return [] }
        let range = scope == .old ? 0..<39 : scope == .new ? 39..<books.count : 0..<books.count
        var hits: [(VerseRef, String)] = []
        for (b, book) in books.enumerated() where range.contains(b) {
            for (c, chapter) in book.chapters.enumerated() {
                for (v, text) in chapter.enumerated() {
                    let t = text.lowercased()
                    if words.allSatisfy(t.contains) {
                        hits.append((VerseRef(place: Place(book: b, chapter: c + 1), verse: v + 1), text))
                        if hits.count == limit { return hits }
                    }
                }
            }
        }
        return hits
    }

    /// Cross references from OpenBible.info (CC BY), top 8 per verse by votes. Loaded on first use.
    private lazy var xrefs: [String: [String]] = Bundle.main.url(forResource: "xrefs", withExtension: "json")
        .flatMap { try? Data(contentsOf: $0) }.flatMap { try? JSONDecoder().decode([String: [String]].self, from: $0) } ?? [:]

    func crossRefs(_ r: VerseRef) -> [VerseRef] {
        (xrefs[r.key] ?? []).compactMap(Marks.ref).filter { verses($0.place).indices.contains($0.verse - 1) }
    }
}
