import XCTest

@testable import BrewCoffee46Core

@MainActor
final class ValidateInputServiceTests: XCTestCase {
    let sut = ValidateInputServiceImpl()

    func test_the_input_coffeebeans_weight_is_less_than_or_equal_0() throws {
        var config = Config.defaultValue
        config.coffeeBeansWeight = 0

        let actual = sut.validate(config: config)
        XCTAssert(actual.isFailure())
        actual.forEachError { error in
            XCTAssertEqual(error, NonEmptyArray(CoffeeError.coffeeBeansWeightUnderZeroError))
        }
    }

    func test_the_input_of_the_number_of_6_is_less_than_or_equal_0() throws {
        var config = Config.defaultValue
        config.partitionsCountOf6 = 0

        let actual = sut.validate(config: config)
        XCTAssert(actual.isFailure())
        actual.forEachError { error in
            XCTAssertEqual(error, NonEmptyArray(CoffeeError.partitionsCountOf6IsNeededAtLeastOne))
        }
    }

    func test_total_time_must_be_longer_than_steaming_time() {
        var config = Config.defaultValue
        config.totalTimeSec = 10

        let actual = sut.validate(config: config)
        XCTAssert(actual.isFailure())
        actual.forEachError { error in
            XCTAssertEqual(error, NonEmptyArray(CoffeeError.steamingTimeIsTooMuchThanTotal))
        }
    }

    func test_the_first_water_percent_is_more_than_0() {
        var config = Config.defaultValue
        config.firstWaterPercent = 0

        let actual = sut.validate(config: config)
        XCTAssert(actual.isFailure())
        actual.forEachError { error in
            XCTAssertEqual(error, NonEmptyArray(CoffeeError.firstWaterPercentIsZeroError))
        }
    }
}
