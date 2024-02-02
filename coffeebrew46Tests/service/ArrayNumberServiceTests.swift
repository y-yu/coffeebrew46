import XCTest

@testable import CoffeeBrew46

final class ArrayNumberServiceTests: XCTestCase {
    let sut = ArrayNumberServiceImpl()
    
    func test_return_array_number_from_double_successfully() throws {
        XCTAssertEqual(sut.fromDouble(digit: 3, from: 12.3), .success(NonEmptyArray(1, [2, 3])))
        XCTAssertEqual(sut.fromDouble(digit: 4, from: 12.3), .success(NonEmptyArray(0, [1, 2, 3])))
        XCTAssertEqual(sut.fromDouble(digit: 3, from: 12.39), .success(NonEmptyArray(1, [2, 3])))
        XCTAssertEqual(sut.fromDouble(digit: 3, from: 0.1), .success(NonEmptyArray(0, [0, 1])))
        XCTAssertEqual(sut.fromDouble(digit: 3, from: 0.0), .success(NonEmptyArray(0, [0, 0])))
        XCTAssertEqual(sut.fromDouble(digit: 1, from: 0.1), .success(NonEmptyArray(1, [])))
    }
    
    func test_return_failure_if_digit_is_less_than_log10_input_double() throws {
        XCTAssert(sut.fromDouble(digit: 2, from: 12.3).isFailure())
    }
    
    func test_return_failure_if_digit_is_less_than_zero() throws {
        XCTAssert(sut.fromDouble(digit: 0, from: 0.0).isFailure())
        XCTAssert(sut.fromDouble(digit: -1, from: -2.0).isFailure())
    }
    
    func test_return_double_from_array_number_successfully() throws {
        XCTAssertEqual(sut.toDoubleWithError([1, 2, 3]), .success(12.3))
        XCTAssertEqual(sut.toDoubleWithError([0, 1, 2, 3]), .success(12.3))
    }
    
    func test_return_failure_if_input_array_number_is_empty() throws {
        XCTAssert(sut.toDoubleWithError([]).isFailure())
    }
}
