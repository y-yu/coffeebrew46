import XCTest

@testable import BrewCoffee46

final class EpochTimeTests: XCTestCase {
    let date: Date = getDate()

    func test_epoch_time_to_date() throws {
        XCTAssertEqual(epochTimeMillis.toDate(), date)
    }

    func test_date_to_epoch_time() throws {
        XCTAssertEqual(date.toEpochTimeMillis(), epochTimeMillis)
    }
}
