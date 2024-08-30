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
