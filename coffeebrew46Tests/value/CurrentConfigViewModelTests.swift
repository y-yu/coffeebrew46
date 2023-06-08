import XCTest
@testable import CoffeeBrew46

class MockValidateInputService: ValidateInputService{
    func validate(config: CoffeeBrew46.Config) -> CoffeeBrew46.ResultNel<Void, CoffeeBrew46.CoffeeError> {
        .success(())
    }
}

class MockCalculateBoiledWaterAmountService: CalculateBoiledWaterAmountService {
    let dummyPointerInfoViewModels: PointerInfoViewModels
    
    init(_ dummyPointerInfoViewModels: PointerInfoViewModels) {
        self.dummyPointerInfoViewModels = dummyPointerInfoViewModels
    }
    
    func calculate(config: CoffeeBrew46.Config) -> CoffeeBrew46.PointerInfoViewModels {
        dummyPointerInfoViewModels
    }
}

class CurrentConfigViewModelTests: XCTestCase {
    let epsilon = 0.0001
    
    func test_toProgressTime_and_toDegree() throws {
        let sut = CurrentConfigViewModel.init(
            validateInputService: MockValidateInputService(),
            calculateBoiledWaterAmountService: MockCalculateBoiledWaterAmountService(
                PointerInfoViewModels.defaultValue()
            )
        )
        
        for d in 0..<360 {
            for f in 0..<9 {
                let degree = Double(d) + (Double(f) / 10)
                
                let progressTime = sut.toProgressTime(degree)
                let actual = sut.toDegree(progressTime)

                XCTAssertEqual(actual, degree, accuracy: epsilon)
            }
        }
    }
    
    func test_toDegree_and_toProgressTime() throws {
        let sut = CurrentConfigViewModel(
            validateInputService: MockValidateInputService(),
            calculateBoiledWaterAmountService: MockCalculateBoiledWaterAmountService(
                PointerInfoViewModels.defaultValue()
            )
        )
        
        for d in 0..<Int(sut.currentConfig.totalTimeSec) {
            for f in 0..<9 {
                let progressTime = Double(d) + (Double(f) / 10)
                
                let degree = sut.toDegree(progressTime)
                let actual = sut.toProgressTime(degree)

                XCTAssertEqual(actual, progressTime, accuracy: epsilon)
            }
        }
    }
    
    func test_dripAt_degree_toProgressTime_toDegree() throws {
        let sut = CurrentConfigViewModel(
            validateInputService: MockValidateInputService(),
            calculateBoiledWaterAmountService: MockCalculateBoiledWaterAmountService(
                PointerInfoViewModels(
                    pointerInfo: [CoffeeBrew46.PointerInfoViewModel(value: 66.528, degree: 0.0, dripAt: 0.0), CoffeeBrew46.PointerInfoViewModel(value: 67.2, degree: 142.56, dripAt: 45.0), CoffeeBrew46.PointerInfoViewModel(value: 100.80000000000001, degree: 144.0, dripAt: 86.25), CoffeeBrew46.PointerInfoViewModel(value: 134.4, degree: 216.0, dripAt: 127.5), CoffeeBrew46.PointerInfoViewModel(value: 168.0, degree: 288.0, dripAt: 168.75)]

                )
            )
        )
        sut.currentConfig.coffeeBeansWeight = 24
        sut.currentConfig.waterToCoffeeBeansWeightRatio = 7
        sut.currentConfig.firstWaterPercent = 0.99
        
        for pointer in sut.pointerInfoViewModels.pointerInfo {
            XCTAssertEqual(sut.toProgressTime(pointer.degree), pointer.dripAt, accuracy: epsilon)
            XCTAssertEqual(sut.toDegree(pointer.dripAt), pointer.degree, accuracy: epsilon)
        }
    }
    
    func test_dripAt_degree_toProgressTime_toDegree_when_40_percent_at_1_shot() throws {
        let sut = CurrentConfigViewModel(
            validateInputService: MockValidateInputService(),
            calculateBoiledWaterAmountService: MockCalculateBoiledWaterAmountService(
                PointerInfoViewModels(
                    pointerInfo: [
                        CoffeeBrew46.PointerInfoViewModel(value: 67.2, degree: 0.0, dripAt: 0.0),
                        CoffeeBrew46.PointerInfoViewModel(value: 100.80000000000001, degree: 144.0, dripAt: 45.0),
                        CoffeeBrew46.PointerInfoViewModel(value: 134.4, degree: 216.0, dripAt: 100),
                        CoffeeBrew46.PointerInfoViewModel(value: 168.0, degree: 288.0, dripAt: 155)
                    ]

                )
            )
        )
        sut.currentConfig.coffeeBeansWeight = 24
        sut.currentConfig.waterToCoffeeBeansWeightRatio = 7
        sut.currentConfig.firstWaterPercent = 1
        
        for pointer in sut.pointerInfoViewModels.pointerInfo {
            XCTAssertEqual(sut.toProgressTime(pointer.degree), pointer.dripAt, accuracy: epsilon)
            XCTAssertEqual(sut.toDegree(pointer.dripAt), pointer.degree, accuracy: epsilon)
        }
    }
}
