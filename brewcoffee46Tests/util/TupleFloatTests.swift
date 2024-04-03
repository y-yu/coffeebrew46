import XCTest

@testable import BrewCoffee46

final class TupleFloatTests: XCTestCase {
    func test_TupleFloat_from_double_successfully() throws {
        XCTAssertEqual(TupleFloat.fromDouble(1, 12.39), .success(TupleFloat.init(integer: 12, decimal: 4, digit: 1)))
        XCTAssertEqual(TupleFloat.fromDouble(0, 12.39), .success(TupleFloat.init(integer: 12, decimal: 0, digit: 0)))
        XCTAssertEqual(TupleFloat.fromDouble(0, 12.5), .success(TupleFloat.init(integer: 13, decimal: 0, digit: 0)))
        XCTAssertEqual(TupleFloat.fromDouble(3, 12.39), .success(TupleFloat.init(integer: 12, decimal: 390, digit: 3)))
        XCTAssertEqual(TupleFloat.fromDouble(1, 14.1), .success(TupleFloat.init(integer: 14, decimal: 1, digit: 1)))

        // negative value
        XCTAssertEqual(TupleFloat.fromDouble(2, -12.39), .success(TupleFloat.init(integer: -12, decimal: 39, digit: 2)))
        XCTAssertEqual(TupleFloat.fromDouble(1, -12.39), .success(TupleFloat.init(integer: -12, decimal: 4, digit: 1)))
    }

    func test_TupleFloat_from_double_returns_error_if_the_digit_is_less_than_0() throws {
        XCTAssert(TupleFloat.fromDouble(-1, 12.39).isFailure())
    }

    func test_to_double_successfully() throws {
        XCTAssertEqual(TupleFloat.init(integer: 12, decimal: 390, digit: 3).toDouble(), 12.39)
        XCTAssertEqual(TupleFloat.init(integer: 12, decimal: 0, digit: 1).toDouble(), 12.0)

        // negative value
        XCTAssertEqual(TupleFloat.init(integer: -12, decimal: 390, digit: 3).toDouble(), -12.39)
        XCTAssertEqual(TupleFloat.init(integer: -12, decimal: 0, digit: 0).toDouble(), -12.0)
    }
}
