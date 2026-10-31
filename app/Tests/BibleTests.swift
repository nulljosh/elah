import XCTest
@testable import Bible

final class BibleTests: XCTestCase {
    let bible = Bible.shared

    func testHomeIsDavidAndGoliath() {
        XCTAssertEqual(bible.title(.home), "1 Samuel 17")
        XCTAssertTrue(bible.verses(.home)[48].contains("smote the Philistine in his forehead"))
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

    func testGatewayURLEncodesReference() {
        XCTAssertEqual(bible.gatewayURL(.home, .niv).absoluteString, "https://www.biblegateway.com/passage/?search=1%20Samuel%2017&version=NIV")
    }
}
