import BrewCoffee46Core
import SwiftUI

struct PointerInfo {
    let dripInfo: DripInfo

    // Degree of the pointers.
    private(set) public var pointerDegrees: [Double]

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

    init() {
        self.init(
            DripInfo(
                dripTimings: [
                    DripTiming(waterAmount: 90, dripAt: 0.0),  // 0.0),
                    DripTiming(waterAmount: 180, dripAt: 72.0),  //, 45.0),
                    DripTiming(waterAmount: 270, dripAt: 144.0),  // 86.25),
                    DripTiming(waterAmount: 360, dripAt: 216.0),  // 127.5),
                    DripTiming(waterAmount: 450, dripAt: 288.0),
                ],
                waterAmount: WaterAmount(
                    fortyPercent: (90.0, 90.0),
                    sixtyPercent: NonEmptyArray(90.0, [90.0, 90.0])
                )
                //, 168.75)
            )
        )
    }
}

/*
extension PointerInfo {
    static func fromArray(_ arr: [Double]) -> PointerInfo {
        PointerInfoViewModel(
            pointerInfo: arr.map { (dripInfo, dripAt) in
                PointerInfoViewModel(
                    dripInfo: dripInfo,
                    degree: degree
                )
            }
        )
    }

    static func fromTuples(_ tuples: (DripInfo, Double)...) -> PointerInfo {
        fromArray(tuples)
    }
}
*/
