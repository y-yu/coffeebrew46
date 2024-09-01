import BrewCoffee46TestsShared
import Factory
import XCTest

@testable import BrewCoffee46Core

final class CalculateDripInfoServiceTests: XCTestCase {
    let sut = CalculateDripInfoServiceImpl()

    final class MockCalculateWaterAmountService: CalculateWaterAmountService {
        let expectedWaterAmount: WaterAmount

        init(_ waterAmount: WaterAmount) {
            expectedWaterAmount = waterAmount
        }

        func calculate(_ config: Config) -> WaterAmount {
            return expectedWaterAmount
        }
    }

    override func setUp() {
        super.setUp()
        Container.shared.reset()
    }

    func test_calculate_if_water_amount_splits_into_5_successfully() throws {
        Container.shared.calculateWaterAmountService.register {
            MockCalculateWaterAmountService(waterAmountDefaultValue)
        }

        let expected = DripInfo.defaultValue

        let actual = sut.calculate(Config.defaultValue)

        XCTAssertEqual(actual, expected)
    }

    func test_calculate_when_the_first_water_amount_is_100_percent_successfully() throws {
        var config = Config.defaultValue
        config.firstWaterPercent = 1.0

        Container.shared.calculateWaterAmountService.register {
            MockCalculateWaterAmountService(waterAmountFirstIs100Percent)
        }

        let actual = sut.calculate(config)

        XCTAssertEqual(actual, dripInfoFirstIs100Percent)
    }

    func test_calculate_when_the_number_of_sixty_percent_is_1() throws {
        var config = Config.defaultValue
        config.firstWaterPercent = 1.0
        config.partitionsCountOf6 = 1

        Container.shared.calculateWaterAmountService.register {
            MockCalculateWaterAmountService(waterAmountFirstIs100PercentSixtyIs1)
        }

        let actual = sut.calculate(config)

        XCTAssertEqual(actual, dripInfoFirstIs100PercentSixtyIs1)
    }
}
