import BrewCoffee46Core
import Factory
import XCTest

@testable import BrewCoffee46

class MockValidateInputService: ValidateInputService {
    func validate(config: Config) -> ResultNea<Void, CoffeeError> {
        .success(())
    }
}

class MockCalculateDripInfoService: CalculateDripInfoService {
    let dummyDripInfo: DripInfo

    init(_ dummyDripInfo: DripInfo) {
        self.dummyDripInfo = dummyDripInfo
    }

    public func calculate(_ config: Config) -> DripInfo {
        dummyDripInfo
    }
}

class CurrentConfigViewModelTests: XCTestCase {
    let epsilon = 0.0001
    let dripInfo = DripInfo(
        dripTimings: [
            DripTiming(waterAmount: 90.0, dripAt: 0.0),
            DripTiming(waterAmount: 180.0, dripAt: 45.0),
            DripTiming(waterAmount: 270.0, dripAt: 86.25),
            DripTiming(waterAmount: 360.0, dripAt: 127.5),
            DripTiming(waterAmount: 450.0, dripAt: 168.75),
        ],
        waterAmount: WaterAmount(
            fortyPercent: (90.0, 90.0),
            sixtyPercent: NonEmptyArray(90.0, [90.0, 90.0])
        )
    )

    override func setUp() {
        super.setUp()
        Container.shared.reset()
    }
}
