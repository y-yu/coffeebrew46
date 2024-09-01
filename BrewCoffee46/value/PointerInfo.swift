import BrewCoffee46Core
import SwiftUI

struct PointerInfo {
    let dripInfo: DripInfo

    // Degree of the pointers.
    private(set) public var pointerDegrees: [Double]

    // This initializer is unsafe. If the number of `dripInfo.dripTimings` is not equal to
    // the number of `pointerDegrees` then the value of `PointerInfo` is inconsistence.
    // So this initializer needs for tests.
    init(_ dripInfo: DripInfo, _ pointerDegrees: [Double]) {
        self.dripInfo = dripInfo
        self.pointerDegrees = pointerDegrees
    }

    init(_ dripInfo: DripInfo) {
        self.dripInfo = dripInfo

        let totalWaterAmount = dripInfo.waterAmount.totalAmount()
        var thisDegree = 0.0
        pointerDegrees = []
        for e in dripInfo.waterAmount.toArray() {
            pointerDegrees.append(thisDegree)
            thisDegree = (e / totalWaterAmount) * 360 + thisDegree
        }
    }
}

extension PointerInfo {
    static let defaultValue: PointerInfo = PointerInfo.init(DripInfo.defaultValue)
}
