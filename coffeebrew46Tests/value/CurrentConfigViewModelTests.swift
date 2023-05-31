import XCTest
@testable import coffeebrew46

class MockValidateInputService: ValidateInputService {
    func validate(config: coffeebrew46.Config) -> coffeebrew46.ResultNel<Void, coffeebrew46.CoffeeError> {
        fatalError("not implemented!")
    }
}

class MockCalculateBoiledWaterAmountService: CalculateBoiledWaterAmountService {
    func calculate(config: coffeebrew46.Config) -> coffeebrew46.PointerInfoViewModels {
        fatalError("not implemented!")
    }
}

class CurrentConfigViewModelTests: XCTestCase {
    let epsilon = 0.0001
    
    func test_toProgressTime_and_toDegree() throws {
        let sut = CurrentConfigViewModel.init(
            validateInputService: MockValidateInputService(),
            calculateBoiledWaterAmountService: MockCalculateBoiledWaterAmountService()
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
        let sut = CurrentConfigViewModel.init(
            validateInputService: MockValidateInputService(),
            calculateBoiledWaterAmountService: MockCalculateBoiledWaterAmountService()
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
}
