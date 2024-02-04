import XCTest

@testable import CoffeeBrew46

final class RoundDouble: XCTestCase {
    func test_roundCentesimal_successfully() throws {
        XCTAssertEqual(roundCentesimal(10.59), 10.6)
        XCTAssertEqual(roundCentesimal(10.55), 10.6)
        XCTAssertEqual(roundCentesimal(10.549), 10.5)
    }
}
