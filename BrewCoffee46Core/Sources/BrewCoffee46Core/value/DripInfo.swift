public struct DripTiming: Equatable {
    public let waterAmount: Double  // gram
    public let dripAt: Double  // sec

    public init(waterAmount: Double, dripAt: Double) {
        self.waterAmount = waterAmount
        self.dripAt = dripAt
    }
}

public func == (lhs: DripTiming, rhs: DripTiming) -> Bool {
    return lhs.waterAmount == rhs.waterAmount && lhs.dripAt == rhs.dripAt
}

public struct DripInfo: Equatable {
    public let dripTimings: [DripTiming]
    public let waterAmount: WaterAmount

    public init(dripTimings: [DripTiming], waterAmount: WaterAmount) {
        self.dripTimings = dripTimings
        self.waterAmount = waterAmount
    }
}

public func == (lhs: DripInfo, rhs: DripInfo) -> Bool {
    return lhs.dripTimings == rhs.dripTimings && lhs.waterAmount == rhs.waterAmount
}

extension DripInfo {
    static public let defaultValue: DripInfo =
        DripInfo(
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

    public func getNthPhase(
        progressTime: Double,
        totalTimeSec: Double
    ) -> Int {
        if progressTime < 0 {
            return 0
        }

        if let nth = dripTimings.firstIndex(where: { e in
            e.dripAt > progressTime
        }) {
            return nth - 1
        } else {
            if progressTime >= totalTimeSec {
                return dripTimings.count
            } else {
                return dripTimings.count - 1
            }
        }
    }
}
