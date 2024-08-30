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
        let expectedWaterAmount = WaterAmount(
            fortyPercent: (90.0, 90.0),
            sixtyPercent: NonEmptyArray(90.0, [90.0, 90.0])
        )
        Container.shared.calculateWaterAmountService.register {
            MockCalculateWaterAmountService(expectedWaterAmount)
        }

        let expected = DripInfo(
            dripTimings: [
                DripTiming(waterAmount: 90.0, dripAt: 0.0),
                DripTiming(waterAmount: 180.0, dripAt: 45.0),
                DripTiming(waterAmount: 270.0, dripAt: 86.25),
                DripTiming(waterAmount: 360.0, dripAt: 127.5),
                DripTiming(waterAmount: 450.0, dripAt: 168.75),
            ],
            waterAmount: expectedWaterAmount
        )

        let actual = sut.calculate(Config.defaultValue)

        XCTAssertEqual(actual, expected)
    }

    func test_calculate_when_the_first_water_amount_is_100_percent_successfully() throws {
        var config = Config.defaultValue
        config.firstWaterPercent = 1.0

        let expectedWaterAmount = WaterAmount(
            fortyPercent: (180.0, 0.0),
            sixtyPercent: NonEmptyArray(90.0, [90.0, 90.0])
        )
        Container.shared.calculateWaterAmountService.register {
            MockCalculateWaterAmountService(expectedWaterAmount)
        }

        let expected = DripInfo(
            dripTimings: [
                DripTiming(waterAmount: 180.0, dripAt: 0.0),
                DripTiming(waterAmount: 270.0, dripAt: 45.0),
                DripTiming(waterAmount: 360.0, dripAt: 100.0),
                DripTiming(waterAmount: 450.0, dripAt: 155.0),
            ],
            waterAmount: expectedWaterAmount
        )

        let actual = sut.calculate(config)

        XCTAssertEqual(actual, expected)
    }

    func test_calculate_when_the_number_of_sixty_percent_is_1() throws {
        var config = Config.defaultValue
        config.firstWaterPercent = 1.0
        config.partitionsCountOf6 = 1
        let expectedWaterAmount = WaterAmount(
            fortyPercent: (180.0, 0.0),
            sixtyPercent: NonEmptyArray(270.0)
        )
        Container.shared.calculateWaterAmountService.register {
            MockCalculateWaterAmountService(expectedWaterAmount)
        }

        let expected = DripInfo(
            dripTimings: [
                DripTiming(waterAmount: 180.0, dripAt: 0.0),
                DripTiming(waterAmount: 450.0, dripAt: 45.0),
            ],
            waterAmount: expectedWaterAmount
        )

        let actual = sut.calculate(config)

        XCTAssertEqual(actual, expected)
    }
}
