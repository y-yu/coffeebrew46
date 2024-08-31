import BrewCoffee46Core
import BrewCoffee46TestsShared
import XCTest

@testable import BrewCoffee46

class ConvertDegreeServiceTests: XCTestCase {
    let epsilon = 0.0001
    let pointerInfo = PointerInfo(dripInfoDefaultValue)

    let sut = ConvertDegreeServiceImpl()

    func test_toProgressTime_and_fromProgressTime() throws {
        for d in 0..<360 {
            for f in 0..<9 {
                let degree = Double(d) + (Double(f) / 10)

                let progressTime = sut.toProgressTime(Config.defaultValue, pointerInfo, degree)
                let actual = sut.fromProgressTime(Config.defaultValue, pointerInfo, progressTime)

                XCTAssertEqual(actual, degree, accuracy: epsilon)
            }
        }
    }

    func test_fromProgressTime_and_toProgressTime() throws {
        for d in 0..<Int(Config.defaultValue.totalTimeSec) {
            for f in 0..<9 {
                let progressTime = Double(d) + (Double(f) / 10)

                let degree = sut.fromProgressTime(Config.defaultValue, pointerInfo, progressTime)
                let actual = sut.toProgressTime(Config.defaultValue, pointerInfo, degree)

                XCTAssertEqual(actual, progressTime, accuracy: epsilon)
            }
        }
    }
    /*
    func test_dripAt_degree_toProgressTime_toDegree() throws {
        Container.shared.validateInputService.register { MockValidateInputService() }
        Container.shared.calculateDripInfoService.register {
            MockCalculateDripInfoService(self.dripInfo)
            MockCalculateBoiledWaterAmountService(
                PointerInfoViewModels(
                    pointerInfo: [
                        PointerInfoViewModel(value: 66.528, degree: 0.0, dripAt: 0.0),
                        PointerInfoViewModel(value: 67.2, degree: 142.56, dripAt: 45.0),
                        PointerInfoViewModel(value: 100.80000000000001, degree: 144.0, dripAt: 86.25),
                        PointerInfoViewModel(value: 134.4, degree: 216.0, dripAt: 127.5),
                        PointerInfoViewModel(value: 168.0, degree: 288.0, dripAt: 168.75),
                    ]

                )
            )
        }

        let sut = CurrentConfigViewModel()

        sut.currentConfig.coffeeBeansWeight = 24
        sut.currentConfig.waterToCoffeeBeansWeightRatio = 7
        sut.currentConfig.firstWaterPercent = 0.99

        for pointer in sut.pointerInfoViewModels.pointerInfo {
            XCTAssertEqual(sut.toProgressTime(pointer.degree), pointer.dripAt, accuracy: epsilon)
            XCTAssertEqual(sut.toDegree(pointer.dripAt), pointer.degree, accuracy: epsilon)
        }
    }

    func test_dripAt_degree_toProgressTime_toDegree_when_40_percent_at_1_shot() throws {
        Container.shared.validateInputService.register { MockValidateInputService() }
        Container.shared.calculateDripInfoService.register {
            MockCalculateBoiledWaterAmountService(
                PointerInfoViewModels(
                    pointerInfo: [
                        PointerInfoViewModel(value: 67.2, degree: 0.0, dripAt: 0.0),
                        PointerInfoViewModel(value: 100.80000000000001, degree: 144.0, dripAt: 45.0),
                        PointerInfoViewModel(value: 134.4, degree: 216.0, dripAt: 100),
                        PointerInfoViewModel(value: 168.0, degree: 288.0, dripAt: 155),
                    ]

                )
            )
        }

        let sut = CurrentConfigViewModel()
        sut.currentConfig.coffeeBeansWeight = 24
        sut.currentConfig.waterToCoffeeBeansWeightRatio = 7
        sut.currentConfig.firstWaterPercent = 1

        for pointer in sut.pointerInfoViewModels.pointerInfo {
            XCTAssertEqual(sut.toProgressTime(pointer.degree), pointer.dripAt, accuracy: epsilon)
            XCTAssertEqual(sut.toDegree(pointer.dripAt), pointer.degree, accuracy: epsilon)
        }
    }
 */
}
