import Foundation

/// A place in the Bible: book index (0 to 65) and chapter (1 based).
struct Place: Codable, Hashable {
    var book: Int
    var chapter: Int
    /// The home passage: David and Goliath.
    static let home = Place(book: 8, chapter: 17)
}

enum Version: String, CaseIterable, Codable, Identifiable {
    case kjv = "KJV", niv = "NIV"
    var id: String { rawValue }
    var title: String { self == .kjv ? "King James Version" : "New International Version" }
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

    /// BibleGateway page for a chapter, used for the NIV, which is licensed and not bundled.
    func gatewayURL(_ p: Place, _ v: Version) -> URL {
        var c = URLComponents(string: "https://www.biblegateway.com/passage/")!
        c.queryItems = [URLQueryItem(name: "search", value: title(p)), URLQueryItem(name: "version", value: v.rawValue)]
        return c.url!
    }
}
