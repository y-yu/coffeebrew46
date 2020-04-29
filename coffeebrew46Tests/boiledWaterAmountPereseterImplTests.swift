import XCTest
import SwiftUI
@testable import coffeebrew46

class boiledWaterAmountPereseterImplTests: XCTestCase {

    let sut: BoiledWaterAmountPresenterImpl = BoiledWaterAmountPresenterImpl()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testItReturnsATextViewIfResultIsRight() throws {
        let ta = 100.0
        let dummyBoiledWaterAmount = BoiledWaterAmount(totalAmount: ta, f: { (ta: Double) in return (ta / 5, ta / 5, ta / 5, ta / 5, ta / 5) })
        let dummyResult: Either<CoffeeError, BoiledWaterAmount> = Either.Right(dummyBoiledWaterAmount)
        
        print("test: \(dummyBoiledWaterAmount.toString())")
        let actual: Text = sut.show(result: dummyResult)
        XCTAssertTrue(actual == Text("Boiled water amounts are " + dummyBoiledWaterAmount.toString()))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

struct boiledWaterAmountPereseterImplTests_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
