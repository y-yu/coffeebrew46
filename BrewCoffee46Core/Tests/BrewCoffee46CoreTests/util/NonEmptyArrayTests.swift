import XCTest

@testable import BrewCoffee46Core

final class NonEmptyArrayTests: XCTestCase {
    func test_count_return_the_number_of_non_empty_array_successfully() throws {
        let nea = NonEmptyArray(1, [2, 3, 4])

        XCTAssertEqual(nea.count(), 4)
    }

    func test_append_successfully() throws {
        let a = NonEmptyArray(1, [2, 3, 4])
        let b = NonEmptyArray(5, [6, 7])
        let c = NonEmptyArray(8)

        let actual = a ++ b ++ c
        XCTAssertEqual(actual, NonEmptyArray(1, [2, 3, 4, 5, 6, 7, 8]))
    }

    func test_getAllErrorMessage_return_all_error_messages_as_string_successfully() throws {
        let errors = NonEmptyArray(
            CoffeeError.coffeeBeansWeightIsNotNumberError,
            [
                CoffeeError.coffeeBeansWeightUnderZeroError,
                CoffeeError.loadedConfigIsNotCompatible,
                CoffeeError.firstWaterPercentIsZeroError,
            ]
        )
        let expected = """
            The coffee beans weight must be number.
            The coffee beans weight must be greater than 0.
            The loaded configuration is not compatible.
            The first water percent must be more than 0.
            """
        let actual = errors.getAllErrorMessage()

        XCTAssertEqual(actual, expected)
    }
}
