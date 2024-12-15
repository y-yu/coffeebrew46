import BrewCoffee46TestsShared
import XCTest

@testable import BrewCoffee46Core

final class CalculateWaterAmountServiceTests: XCTestCase {
    let sut = CalculateWaterAmountServiceImpl()

    func test_calculate_in_default_config() throws {
        let actual = sut.calculate(Config.defaultValue())

        XCTAssertEqual(actual, waterAmountDefaultValue)
    }

    func test_calculate_in_the_first_is_100_percent() throws {
        var config = Config.defaultValue()
        config.firstWaterPercent = 1.0

        let actual = sut.calculate(config)

        XCTAssertEqual(actual, waterAmountFirstIs100Percent)
    }

    func test_calculate_in_the_first_is_100_percent_and_the_number_of_sixty_is_1() throws {
        var config = Config.defaultValue()
        config.firstWaterPercent = 1.0
        config.partitionsCountOf6 = 1

        let actual = sut.calculate(config)

        XCTAssertEqual(actual, waterAmountFirstIs100PercentSixtyIs1)
    }
}
