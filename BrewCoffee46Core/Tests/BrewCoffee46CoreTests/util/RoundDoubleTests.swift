import XCTest

@testable import BrewCoffee46Core

final class RoundDoubleTests: XCTestCase {
    func test_roundCentesimal_successfully() throws {
        XCTAssertEqual(roundCentesimal(10.59), 10.6)
        XCTAssertEqual(roundCentesimal(10.55), 10.6)
        XCTAssertEqual(roundCentesimal(10.549), 10.5)
        XCTAssertEqual(roundCentesimal(238.70000000000002), 238.7)
    }
}
