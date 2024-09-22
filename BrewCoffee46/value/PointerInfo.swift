import BrewCoffee46Core
import SwiftUI

struct PointerInfo {
    let dripInfo: DripInfo

    // Degree of the pointers.
    public let pointerDegrees: [Double]

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
        var degrees: [Double] = []
        for e in dripInfo.waterAmount.toArray() {
            degrees.append(thisDegree)
            thisDegree = (e / totalWaterAmount) * 360 + thisDegree
        }
        self.pointerDegrees = degrees
    }
}

extension PointerInfo {
    static public let defaultValue: PointerInfo = PointerInfo.init(DripInfo.defaultValue)
}
