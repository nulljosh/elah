import XCTest
import SwiftUI
import ImageIO
@testable import Bible

final class BibleTests: XCTestCase {
    let bible = Bible.shared

    func testEveryVersionCarriesTheWholeCanon() {
        for v in Version.allCases {
            let first = bible.verses(Place(book: 0, chapter: 1), v), goliath = bible.verses(.home, v)
            XCTAssertFalse(first.first?.isEmpty ?? true, "\(v.rawValue) Genesis 1")
            XCTAssertEqual(goliath.count, 58, "\(v.rawValue) 1 Samuel 17")
            XCTAssertFalse(bible.verses(Place(book: 65, chapter: 22), v).isEmpty, "\(v.rawValue) Revelation 22")
        }
    }

    func testHomeIsDavidAndGoliath() {
        XCTAssertEqual(bible.title(.home), "1 Samuel 17")
        XCTAssertTrue(bible.verses(.home)[48].contains("smote the Philistine in his forehead"))
    }

    func testCrossRefs() {
        let refs = bible.crossRefs(VerseRef(place: Place(book: 0, chapter: 1), verse: 1))
        XCTAssertEqual(refs.first, VerseRef(place: Place(book: 42, chapter: 1), verse: 1), "Genesis 1:1 leads to John 1:1")
        XCTAssertLessThanOrEqual(refs.count, 8)
    }

    func testDailyVersePlan() {
        let morning = Calendar.current.date(from: DateComponents(year: 2026, month: 11, day: 2, hour: 7))!
        let plan = DailyVerse.plan(from: morning, minute: 8 * 60)
        XCTAssertEqual(plan.count, DailyVerse.days, "8:00 is still ahead at 7:00, so today counts")
        XCTAssertEqual(Calendar.current.component(.hour, from: plan[0].date), 8)
        XCTAssertEqual(plan[0].cite + " KJV", "\(TodayView.ofTheDay(morning)) KJV")
        XCTAssertEqual(DailyVerse.plan(from: morning, minute: 6 * 60).count, DailyVerse.days - 1, "6:00 has passed, today is skipped")
    }

    func testPlansCoverEveryChapterOnce() {
        for plan in Plan.all {
            let days = (0..<plan.days).flatMap { plan.day($0) }
            XCTAssertEqual(days, plan.chapters(), plan.name)
            XCTAssertFalse(plan.day(0).isEmpty, plan.name)
        }
        XCTAssertEqual(Plan.find("year")?.chapters().count, 1189)
    }

    func testWholeCanon() {
        XCTAssertEqual(bible.books.count, 66)
        XCTAssertEqual(bible.books.reduce(0) { $0 + $1.chapters.count }, 1189)
    }

    func testChapterStepsCrossBooks() {
        XCTAssertEqual(bible.next(Place(book: 0, chapter: 50)), Place(book: 1, chapter: 1))
        XCTAssertEqual(bible.previous(Place(book: 1, chapter: 1)), Place(book: 0, chapter: 50))
        XCTAssertNil(bible.previous(Place(book: 0, chapter: 1)))
        XCTAssertNil(bible.next(Place(book: 65, chapter: 22)))
    }
}

final class MarksTests: XCTestCase {
    func testHighlightAndBookmarkPersist() {
        let d = UserDefaults(suiteName: "marks-test")!
        d.removePersistentDomain(forName: "marks-test")
        let r = VerseRef(place: .home, verse: 49)
        let m = Marks(defaults: d)
        m.setHighlight(r, 2); m.toggleBookmark(r)
        let again = Marks(defaults: d)
        XCTAssertEqual(again.highlight(r), 2)
        XCTAssertTrue(again.isBookmarked(r))
        again.setHighlight(r, nil); again.toggleBookmark(r)
        XCTAssertNil(Marks(defaults: d).highlight(r))
        XCTAssertFalse(Marks(defaults: d).isBookmarked(r))
    }
}

final class SearchTests: XCTestCase {
    func testFindsGoliathsForehead() {
        let hits = Bible.shared.search("stone forehead")
        XCTAssertTrue(hits.contains { $0.ref == VerseRef(place: .home, verse: 49) })
        XCTAssertTrue(Bible.shared.search("   ").isEmpty)
        XCTAssertEqual(Bible.shared.search("the", limit: 10).count, 10)
    }
}

final class TodayTests: XCTestCase {
    func testEveryVerseOfTheDayResolves() {
        for s in TodayView.verses { XCTAssertNotNil(Bible.shared.ref(s), s) }
        XCTAssertNil(Bible.shared.ref("1 Samuel 17:99"))
        XCTAssertNil(Bible.shared.ref("Hezekiah 1:1"))
    }
}

final class NotesTests: XCTestCase {
    func testNotesPersistAndBlankDeletes() {
        let d = UserDefaults(suiteName: "notes-test")!
        d.removePersistentDomain(forName: "notes-test")
        let r = VerseRef(place: .home, verse: 45)
        Marks(defaults: d).setNote(r, "  In the name of the LORD  ")
        XCTAssertEqual(Marks(defaults: d).note(r), "In the name of the LORD")
        Marks(defaults: d).setNote(r, "   ")
        XCTAssertNil(Marks(defaults: d).note(r))
        XCTAssertEqual(Marks.ref(r.key), r)
    }
}

final class VerseCardTests: XCTestCase {
    @MainActor func testCardRendersSquare() throws {
        let r = ImageRenderer(content: VerseCard(text: Bible.shared.verses(.home)[44], cite: "1 Samuel 17:45 KJV"))
        let cg = try XCTUnwrap(r.cgImage)
        XCTAssertEqual(cg.width, 1080); XCTAssertEqual(cg.height, 1080)
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("verse-card.png")
        let dest = CGImageDestinationCreateWithURL(url as CFURL, "public.png" as CFString, 1, nil)!
        CGImageDestinationAddImage(dest, cg, nil); CGImageDestinationFinalize(dest)
        print("CARD", url.path)
    }
}

final class ScopeTests: XCTestCase {
    func testScopeAndPhrase() {
        let b = Bible.shared
        XCTAssertTrue(b.search("Goliath", scope: .new).isEmpty)
        XCTAssertFalse(b.search("Goliath", scope: .old).isEmpty)
        let phrase = b.search("\u{201C}five smooth stones\u{201D}")
        XCTAssertEqual(phrase.count, 1)
        XCTAssertEqual(phrase.first?.ref, VerseRef(place: .home, verse: 40))
        XCTAssertGreaterThan(b.search("smooth stones").count, b.search("\"five smooth stones\"").count - 1)
    }
}
