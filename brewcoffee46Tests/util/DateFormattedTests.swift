import XCTest

@testable import BrewCoffee46

final class DateFormattedTests: XCTestCase {
    func test_date_formatted_contains_seconds() throws {
        let date = getDate()
        XCTAssert(date.formattedWithSec().contains(":39"))
    }
}
